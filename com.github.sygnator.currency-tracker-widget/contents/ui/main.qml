import QtQuick 2.15
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    // Window parameters
    id: window
    width: 120
    height: 12
    // Background transparency
    Plasmoid.backgroundHints: PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground

    function getApiUrl(currencyFrom, currencyTo) {
        // yahoo finance - 500 request per day
        return "https://query1.finance.yahoo.com/v7/finance/spark?symbols=" + currencyFrom + currencyTo + "=X&range=1m";
    }

    function getSymbol(regularPrice, previousClose) {
        if (regularPrice > previousClose) return {symbol: "▲", color: "#0f0"} // green color
        else if (regularPrice < previousClose) return {symbol: "▼", color: "#dd0404"} // red color
        else return {icon: "−", colro: "white"}

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
                    if (Plasmoid.configuration.showIcon) {
                        var exchangeSymbol = getSymbol(meta.regularMarketPrice, meta.previousClose);
                        labelIcon.text = exchangeSymbol.symbol;
                        labelIcon.color = exchangeSymbol.color;
                    }

                    apiLabel.text = "1 " + currencyFrom + " - " + meta.regularMarketPrice + " " + currencyTo;

                    // Restart timer to default value
                    timer.interval = 600000;

                } else {
                    // Handle errors
                    console.error("Error making API request:", xhr.status, xhr.statusText);
                    timer.interval = 5000;
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

    RowLayout {
        // Center text in window
        anchors.centerIn: parent

        PlasmaComponents.Label {
            id: labelIcon
            font.pixelSize: window.width / 12
            text: i18n("")
        }

        PlasmaComponents.Label {
            id: apiLabel
            font.pixelSize: window.width/ 12
            text: i18n("Loading data...", makeApiRequest(Plasmoid.configuration.exchangeFrom, Plasmoid.configuration.exchangeTo))
        }
    }

    // Refresh every 10 minute
    Timer {
        id: timer
        interval: 600000
        running: true
        repeat: true

        onTriggered: {
            makeApiRequest("USD", "EUR");
        }
    }
}
