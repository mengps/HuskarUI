#include "creator.h"
#include "creator_p.h"

#include <QDir>
#include <QDesktopServices>

static void copyDirectory(const QString &from, const QString &to, bool overwrite = true)
{
    QDir fromDir(from);
    if (fromDir.exists()) {
        QDir toDir(to);
        if (!toDir.exists())
            toDir.mkpath(toDir.path());
        for (const auto &item : fromDir.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot)) {
            QString srcItemPath = fromDir.path() + "/" + item.fileName();
            QString dstItemPath = toDir.path() + "/" + item.fileName();
            if (item.isDir()) {
                /*! 递归拷贝子目录 */
                copyDirectory(srcItemPath, dstItemPath);
            } else if (item.isFile()) {
                /*! 删除已存在的文件 */
                if (overwrite && QFile::exists(dstItemPath)) {
                    if (!QFile::remove(dstItemPath)) {
                        qWarning() << "Failed to remove existing file:" << dstItemPath;
                    }
                }
                /*! 拷贝文件 */
                if (!QFile::copy(srcItemPath, dstItemPath)) {
                    qWarning() << "Failed to copy file:" << srcItemPath << "to" << dstItemPath;
                }
            }
        }
    }
}

static void genFileAndCode(const QString &fileName, const QString &code)
{
    QDir dir(QFileInfo(fileName).path());
    if (!dir.exists())
        dir.mkdir(dir.path());

    QFile file(fileName);
    if (file.open(QIODevice::Truncate | QIODevice::WriteOnly)) {
        file.write(code.toUtf8());
        file.close();
    } else {
        qDebug() << QString("The %1 cannot be created! Error: %2").arg(fileName, file.errorString());
    }
}

Creator *Creator::instance()
{
    static Creator *ins = new Creator;
    return ins;
}

Creator *Creator::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

QUrl Creator::localFileToUrl(const QString &file)
{
    return QUrl::fromLocalFile(file);
}

QString Creator::urlToLocalFile(const QUrl &url)
{
    return url.toLocalFile();
}

void Creator::createProject(const QVariant &projectParams)
{
    auto params = projectParams.toMap();
    auto projectName = params["projectName"].toString();
    auto projectLocation = params["projectLocation"].toString();
    auto containMethod = ContainMethod(params["containMethod"].toInt());
    auto isDefaultBuild = params["isDefaultBuild"].toBool();
    auto sourceLocation = params["sourceLocation"].toString();
    auto addDeployScript = params["addDeployScript"].toBool();
    auto isShareLibrary = params["isShareLibrary"].toBool();

    QDir projectDir(projectLocation + "/" + projectName);
    if (!projectDir.exists())
        projectDir.mkdir(projectDir.path());

    QFile projectCmake(projectDir.path() + "/CMakeLists.txt");
    if (projectCmake.open(QIODevice::Truncate | QIODevice::WriteOnly)) {
        switch (containMethod) {
        case ContainMethod::NoContain:
        {
            genFileAndCode(projectDir.path() + "/main.cpp", QString(g_nocontain_main_cpp_file).arg(projectName));
            genFileAndCode(projectDir.path() + "/Main.qml", QString(g_nocontain_main_qml_file).arg(projectName));

            QString cmakeLists = QString(g_cmake_project).arg(projectName) +
                                 QString(g_cmake_install) +
                                 QString(g_cmake_nocontain_link) +
                                 (addDeployScript ? QString(g_cmake_deploy) : "");
            projectCmake.write(cmakeLists.toUtf8());
        } break;
        case ContainMethod::SourceContain:
        {
            projectCmake.write(QString(g_cmake_src_subdirectory).arg(projectName, isShareLibrary ? "OFF" : "ON").toUtf8());

            genFileAndCode(projectDir.path() + "/src/main.cpp", QString(g_main_cpp_file).arg(projectName));
            genFileAndCode(projectDir.path() + "/src/Main.qml", QString(g_main_qml_file).arg(projectName));

            copyDirectory(sourceLocation + "/3rdparty", projectDir.path() + "/3rdparty");
            copyDirectory(sourceLocation + "/.cmake", projectDir.path() + "/3rdparty/.cmake");
            copyDirectory(sourceLocation + "/src", projectDir.path() + "/3rdparty/HuskarUI");

            QString srcCmake = QString(g_cmake_project).arg(projectName) +
                               QString(g_cmake_only_link_huskarui) +
                               QString(g_cmake_install) +
                               (addDeployScript ? QString(g_cmake_deploy) : "");
            genFileAndCode(projectDir.path() + "/src/CMakeLists.txt", srcCmake);
        } break;
        case ContainMethod::LibraryContain:
        {
            projectCmake.write(QString(g_cmake_lib_subdirectory).arg(projectName, isShareLibrary ? "OFF" : "ON").toUtf8());

            genFileAndCode(projectDir.path() + "/src/main.cpp",
                           isDefaultBuild ?
                               QString(g_main_cpp_file).arg(projectName) :
                               QString(g_main_add_import_cpp_file).arg(projectName));
            genFileAndCode(projectDir.path() + "/src/Main.qml", QString(g_main_qml_file).arg(projectName));

            if (!isDefaultBuild)
                copyDirectory(sourceLocation, projectDir.path() + "/3rdparty/HuskarUI");

            QString includeDir = isDefaultBuild ?
                                     "${Qt6_DIR}/../../../include/HuskarUI" :
                                     "${CMAKE_SOURCE_DIR}/3rdparty/HuskarUI/include";
            QString libDir = isDefaultBuild ?
                                 "${Qt6_DIR}/../../../lib" :
                                 "${CMAKE_SOURCE_DIR}/3rdparty/HuskarUI/lib";

            QString srcCmake = QString(g_cmake_project).arg(projectName) +
                               (isDefaultBuild ? "" : QString(g_cmake_qml_import)) +
                               QString(g_cmake_link_huskarui).arg(includeDir, libDir) +
                               QString(g_cmake_install) +
                               (addDeployScript ? QString(g_cmake_deploy) : "");
            genFileAndCode(projectDir.path() + "/src/CMakeLists.txt", srcCmake);
        } break;
        default:
            break;
        }
        QDesktopServices::openUrl(QUrl::fromLocalFile(projectDir.path()));
    } else {
        qDebug() << "The CMakeLists.txt cannot be created! Error: " + projectCmake.errorString();
    }
}
