import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Item {
    id: page
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_showIcon: showIcon.checked
    property alias cfg_exchangeFrom: exchangeFrom.text
    property alias cfg_exchangeTo: exchangeTo.text

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        CheckBox {
            id: showIcon
            text: i18n("Show icon")
            checked: true
        }
        TextField {
            id: exchangeFrom
            Kirigami.FormData.label: i18n("Exchange from:")
        }
        TextField {
            id: exchangeTo
            Kirigami.FormData.label: i18n("Exchange to:")
        }
    }
}
