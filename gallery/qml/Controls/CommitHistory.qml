import QtQuick
import HuskarUI.Basic

Column {
    id: root
    spacing: 15
    Component.onCompleted: fetchCommits();

    property url source: ''
    property bool loading: false
    property var commits: []
    property var tags: []  // 添加标签存储

    function getRepoInfoFromUrl(fileUrl: url): var {
        /*! 示例: https://github.com/mengps/HuskarUI/blob/master/src/imports/HusAcrylic.qml */
        /*！转换为: owner=mengps, repo=HuskarUI, path=src/imports/HusAcrylic.qml */
        let urlStr = fileUrl.toString();
        let match = urlStr.match(/github\.com\/([^\/]+)\/([^\/]+)\/blob\/([^\/]+)\/(.+)/);
        if (match) {
            return {
                owner: match[1],
                repo: match[2],
                branch: match[3],
                path: match[4]
            };
        }
        return null;
    }

    function fetchTags(repoInfo: var, finishedCallback: var) {
        let tagsUrl = `https://api.github.com/repos/${repoInfo.owner}/${repoInfo.repo}/tags`;
        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = () => {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        root.tags = JSON.parse(xhr.responseText);
                        finishedCallback();
                    } catch (e) {
                        console.error('Error parsing tags JSON:', e);
                    }
                } else {
                    console.error('Tags request failed with status:', xhr.status);
                }
            }
        };
        xhr.open('GET', tagsUrl);
        xhr.setRequestHeader('Accept', 'application/vnd.github.v3+json');
        xhr.send();
    }

    function fetchCommits() {
        loading = true;

        let repoInfo = getRepoInfoFromUrl(source);
        if (!repoInfo) {
            console.error('Invalid GitHub file URL format');
            loading = false;
            return;
        }

        fetchTags(repoInfo,
                  () => {
                      let apiUrl = `https://api.github.com/repos/${repoInfo.owner}/${repoInfo.repo}/commits?path=${repoInfo.path}`;
                      let xhr = new XMLHttpRequest();
                      xhr.onreadystatechange = () => {
                          if (xhr.readyState === XMLHttpRequest.DONE) {
                              loading = false;
                              if (xhr.status === 200) {
                                  try {
                                      const data = JSON.parse(xhr.responseText);
                                      processCommits(data);
                                  } catch (e) {
                                      console.error('Error parsing JSON:', e);
                                  }
                              } else {
                                  console.error('Request failed with status:', xhr.status);
                              }
                          }
                      };
                      xhr.open('GET', apiUrl);
                      xhr.setRequestHeader('Accept', 'application/vnd.github.v3+json');
                      xhr.send();
                  });
    }

    function processCommits(data) {
        const timelineData = [];
        for (let i = 0; i < data.length; i++) {
            const commit = data[i];
            const dateText = new Date(commit.commit.committer.date).toLocaleString(Qt.locale(), 'yyyy-MM-dd');
            /*! 查找与当前提交关联的标签 */
            let commitTags = [];
            for (let j = 0; j < root.tags.length; j++) {
                if (root.tags[j].commit && root.tags[j].commit.sha === commit.sha) {
                    commitTags.push(root.tags[j].name);
                }
            }
            let version = commitTags.join('.');
            timelineData.push({
                                  tag: dateText,
                                  version: version,
                                  content: 'Author: ' + commit.commit.author.name + '\n' +
                                           'Message: ' + commit.commit.message + '\n'

                              });
        }
        commits = timelineData;
    }

    HusText {
        text: qsTr('更新历史')
        font {
            pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
            weight: Font.DemiBold
        }
    }

    Rectangle {
        width: parent.width
        height: 150
        radius: HusTheme.Primary.radiusPrimary
        color: HusTheme.Primary.colorFillQuaternary
        border.color: HusTheme.Primary.colorBorder

        HusTimeline {
            id: timeline
            anchors.fill: parent
            anchors.margins: 10
            initModel: root.commits
            contentDelegate: Column {
                spacing: 10
                topPadding: 4
                Component.onCompleted: timeline.positionViewAtBeginning();

                Row {
                    spacing: 5

                    HusTag {
                        presetColor: 'cyan'
                        text: model.tag
                    }

                    HusTag {
                        presetColor: 'red'
                        visible: model.version !== ''
                        text: model.version
                    }
                }

                HusText {
                    width: parent.width
                    color: timeline.colorContentText
                    font: timeline.contentFont
                    text: model.content
                    lineHeight: 1.2
                    wrapMode: Text.WordWrap
                    horizontalAlignment: onLeft ? Text.AlignRight : Text.AlignLeft
                }
            }
        }

        HusSpin {
            anchors.centerIn: parent
            visible: root.loading
            spinning: root.loading
            tip: qsTr('正在加载提交记录...')
            sizeHint: 'large'
        }
    }
}

