import QtQuick 2.15
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

ColumnLayout {
    function getApiUrl(currencyFrom, currencyTo) {
        // yahoo finance - 500 request per day
        return "https://query1.finance.yahoo.com/v7/finance/spark?symbols=" + currencyFrom + currencyTo + "=X&range=1m";
    }

    function getSymbol(regularPrice, previousClose) {
        if (regularPrice > previousClose) return "▲"
        else if (regularPrice < previousClose) return "▼"
        else return "−"

    }

    function makeApiRequest(currencyFrom, currencyTo) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    // API request was successful
                    var res = JSON.parse(xhr.responseText);

                    // Access meta from the response
                    var meta = res.spark.result[0].response[0].meta;

                    // Display currency exchange
                    apiLabel.text = getSymbol(meta.regularMarketPrice, meta.previousClose) + " 1 " + currencyFrom + " - " + meta.regularMarketPrice + " " + currencyTo;
                    console.log(meta.regularMarketTime)

                } else {
                    // Handle errors
                    console.error("Error making API request:", xhr.status, xhr.statusText);
                }
            }
        };

        // Send API request
        xhr.open("GET", getApiUrl(currencyFrom, currencyTo), true);
        xhr.send();
    }

    // PlasmaComponents.Button {
    //     id: apiButton
    //     text: "Make API Request"
    //     onClicked: {
    //         makeApiRequest("USD", "EUR");
    //     }
    // }

    PlasmaComponents.Label {
        id: apiLabel
        text: i18n("Loading data...", makeApiRequest("USD", "EUR"))
    }

    // Refresh every 5 minute
    Timer {
        interval: 300000
        running: true
        repeat: true

        onTriggered: {
            makeApiRequest("USD", "EUR");
        }
    }
}
