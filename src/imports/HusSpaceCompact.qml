import QtQuick
import DelegateUI

Loader {
    id: control

    sourceComponent: orientation == Qt.Horizontal ? __rowComp : __columnComp

    property int orientation: Qt.Horizontal
    property int radius: 0
    property int spacing: 0

    QtObject {
        id: __private

        function removeRadius(child) {
            if (child instanceof DelRectangle || child instanceof Rectangle)
                child.radius = 0;
            if (child instanceof DelInputNumber || child instanceof DelButton || child instanceof DelIconButton)
                child.radiusBg = 0;
        }
    }

    Component {
        id: __rowComp

        Row {
            spacing: control.spacing
            Component.onCompleted: {
                for (let i = 0; i < children.length; i++) {
                    if (i == 0 || i == children.length - 1) {
                        let child = children[i];
                        if (child instanceof DelRectangle) {
                            if (i == 0) {
                                child.topLeftRadius = Qt.binding(() => control.radius);
                                child.bottomLeftRadius = Qt.binding(() => control.radius);
                            } else {
                                child.topRightRadius = Qt.binding(() => control.radius);
                                child.bottomRightRadius = Qt.binding(() => control.radius);
                            }
                        }
                    }

                    if (i > 0 && i < children.length) {
                        __private.removeRadius(child);
                    }
                }
            }
        }
    }

    Component {
        id: __columnComp

        Column {
            spacing: control.spacing
            Component.onCompleted: {
                for (let i = 0; i < children.length; i++) {
                    if (i == 0 || i == children.length - 1) {
                        let child = children[i];
                        if (child instanceof DelRectangle) {
                            if (i == 0) {
                                child.topLeftRadius = Qt.binding(() => control.radius);
                                child.topRightRadius = Qt.binding(() => control.radius);
                            } else {
                                child.bottomLeftRadius = Qt.binding(() => control.radius);
                                child.bottomRightRadius = Qt.binding(() => control.radius);
                            }
                        }
                    }

                    if (i > 0 && i < children.length) {
                        __private.removeRadius(child);
                    }
                }
            }
        }
    }
}
