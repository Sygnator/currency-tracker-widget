import QtQuick 2.15
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

ColumnLayout {
    function makeApiRequest() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    // API request was successful
                    var res = JSON.parse(xhr.responseText)
                    console.log(res, res[0], res[0].name);
                    apiLabel.text = res[0].name
                } else {
                    // Handle errors
                    console.error("Error making API request:", xhr.status, xhr.statusText);
                }
            }
        };

        // Send API request
        xhr.open("GET", "some api", true);
        xhr.send();
    }

    PlasmaComponents.Button {
        id: apiButton
        text: "Make API Request"
        onClicked: {
            makeApiRequest();
        }
    }

    PlasmaComponents.Label {
        id: apiLabel
        text: i18n("Loading data...", makeApiRequest())
    }
}
