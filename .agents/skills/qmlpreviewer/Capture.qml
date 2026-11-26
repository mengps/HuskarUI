import QtQuick
import QtTest

Window {
    id: host

    property Window __previewWindow: host
    property string __outputPath

    width: 800
    height: 600
    title: qsTr("QML Preview")

    Component.onCompleted: {
        const args = Qt.application.arguments;
        __outputPath = args[args.length - 2];
        capture.interval = Number(args[args.length - 1]);
        preview.source = args[args.length - 3];
    }

    function __fail(message: string) {
        console.error(message);
        Qt.exit(1);
    }

    Loader {
        id: preview

        onStatusChanged: {
            if (status === Loader.Error)
                host.__fail("Could not load QML: " + source);
        }

        onLoaded: {
            if (item instanceof Window) {
                host.__previewWindow = item;
                item.transientParent = null;
                if (item.width <= 0)
                    item.width = host.width;
                if (item.height <= 0)
                    item.height = host.height;
            } else if (item instanceof Item) {
                host.width = item.width > 0 ? Math.ceil(item.width) : host.width;
                host.height = item.height > 0 ? Math.ceil(item.height) : host.height;
                width = host.width;
                height = host.height;
            } else {
                host.__fail("The QML root must be an Item or a Window.");
                return;
            }

            host.__previewWindow.visible = true;
            capture.start();
        }
    }

    TestCase {
        id: screenshot
        when: false
    }

    Timer {
        id: capture

        onTriggered: {
            // ApplicationWindow can have a content item below its header and footer.
            let content = host.__previewWindow.contentItem;
            while (content.parent)
                content = content.parent;

            try {
                screenshot.grabImage(content).save(host.__outputPath);
                Qt.quit();
            } catch (error) {
                host.__fail("Could not capture preview: " + error);
            }
        }
    }
}
