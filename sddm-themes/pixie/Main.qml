/**
 * Pixie SDDM - macOS Layout Variant
 * Based on Pixie SDDM by xCaptaiN09 (https://github.com/xCaptaiN09/pixie-sddm)
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "components"

FocusScope {
    id: container
    width: 1920
    height: 1080
    focus: true
    activeFocusOnTab: true

    property int userIndex: 0
    property int sessionIndex: 0
    property bool isLoggingIn: false
    property bool passwordRevealed: false

    Component.onCompleted: {
        if (typeof userModel !== "undefined" && userModel.lastIndex >= 0) userIndex = userModel.lastIndex;
        if (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) sessionIndex = sessionModel.lastIndex;
        passwordField.focus = false;
        refocusTimer.restart();
    }

    onActiveFocusChanged: {
        if (!activeFocus && !container.passwordRevealed && !userPopup.opened && !sessionPopup.opened) {
            refocusTimer.restart();
        }
    }

    onPasswordRevealedChanged: {
        if (!passwordRevealed) {
            passwordField.focus = false;
            passwordField.text = "";
            refocusTimer.restart();
        } else {
            passwordFocusTimer.restart();
        }
    }

    Timer {
        id: refocusTimer
        interval: 50
        repeat: false
        onTriggered: {
            if (!container.passwordRevealed && !userPopup.opened && !sessionPopup.opened) {
                passwordField.focus = false;
                if (!container.activeFocus) {
                    container.forceActiveFocus();
                }
            }
        }
    }

    Timer {
        id: passwordFocusTimer
        interval: 60
        repeat: false
        onTriggered: {
            if (container.passwordRevealed && !userPopup.opened && !sessionPopup.opened) {
                passwordField.forceActiveFocus();
            }
        }
    }

    function cleanName(name) {
        if (!name) return "";
        var s = name.toString();
        if (s.endsWith("/")) s = s.substring(0, s.length - 1);
        if (s.indexOf("/") !== -1) s = s.substring(s.lastIndexOf("/") + 1);
        if (s.indexOf(".desktop") !== -1) s = s.substring(0, s.indexOf(".desktop"));
        s = s.replace(/[-_]/g, ' ');
        return s;
    }

    function revealPassword() {
        if (!container.passwordRevealed) {
            container.passwordRevealed = true;
            passwordFocusTimer.restart();
        } else {
            passwordField.forceActiveFocus();
        }
    }

    function hidePassword() {
        container.passwordRevealed = false;
        passwordField.focus = false;
        passwordField.text = "";
        refocusTimer.restart();
    }

    function doLogin() {
        if (!container.passwordRevealed || isLoggingIn) return;

        var user = "";
        if (typeof userModel !== "undefined" && userModel.count > 0) {
            var idx = container.userIndex;
            if (idx < 0 || idx >= userModel.count) idx = 0;

            var edit = userModel.data(userModel.index(idx, 0), Qt.EditRole);
            var nameRole = userModel.data(userModel.index(idx, 0), Qt.UserRole + 1);
            var display = userModel.data(userModel.index(idx, 0), Qt.DisplayRole);

            user = edit ? edit.toString() : (nameRole ? nameRole.toString() : (display ? display.toString() : ""));
        }

        if (!user || user === "" || user === "User") {
            user = sddm.lastUser;
        }

        if (!user && typeof userModel !== "undefined" && userModel.count > 0) {
            var firstEdit = userModel.data(userModel.index(0, 0), Qt.EditRole);
            user = firstEdit ? firstEdit.toString() : "";
        }

        if (!user) return;

        container.isLoggingIn = true;
        var pass = passwordField.text;
        var sess = container.sessionIndex;

        if (typeof sessionModel !== "undefined") {
            if (sess < 0 || sess >= sessionModel.count) sess = 0;
        } else {
            sess = 0;
        }

        sddm.login(user.trim(), pass, sess);
        loginTimeout.start();
    }

    Timer {
        id: loginTimeout
        interval: 5000
        onTriggered: container.isLoggingIn = false
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            container.isLoggingIn = false
            loginTimeout.stop()
            container.passwordRevealed = true
            shakeAnimation.start()
            passwordField.text = ""
            passwordField.forceActiveFocus()
        }
        function onLoginSucceeded() {
            loginTimeout.stop()
        }
    }

    property color extractedAccent: config.accentColor
    property color baseColor: config.backgroundColor
    property color surfaceColor: Qt.lighter(baseColor, 1.3)
    property color surfaceVariantColor: Qt.lighter(baseColor, 1.6)
    property bool uiReady: config.autoColor !== "true" || colorExtractor.processed

    Rectangle {
        anchors.fill: parent
        color: config.backgroundColor
    }

    Timer {
        id: colorDelay
        interval: 1000
        repeat: true
        running: backgroundImage.status === Image.Ready && !colorExtractor.processed && config.autoColor === "true"
        onTriggered: colorExtractor.requestPaint()
    }

    Canvas {
        id: colorExtractor
        width: 60; height: 60
        x: -100; y: -100
        z: -1
        renderTarget: Canvas.Image
        property bool processed: false
        property int retries: 0

        onPaint: {
            var ctx = getContext("2d");
            var res = 60;
            ctx.clearRect(0, 0, res, res);
            ctx.drawImage(backgroundImage, 0, 0, res, res);
            var imgData = ctx.getImageData(0, 0, res, res).data;

            if (!imgData || imgData.length === 0) return;

            var histogram = new Array(36).fill(0);
            var sampleColors = new Array(36).fill(null);
            var vibrantFound = false;

            var pixelSum = 0;
            for (var p = 0; p < imgData.length; p++) pixelSum += imgData[p];

            if (pixelSum === 0) {
                retries++;
                if (retries > 3) {
                    container.extractedAccent = "#D0D0D0";
                    processed = true;
                }
                return;
            }

            retries = 0;

            for (var i = 0; i < imgData.length; i += 4) {
                var r = imgData[i] / 255;
                var g = imgData[i+1] / 255;
                var b = imgData[i+2] / 255;
                var pCol = Qt.rgba(r, g, b, 1.0);

                if (pCol.hsvSaturation > 0.3 && pCol.hsvValue > 0.15) {
                    var h = pCol.hsvHue * 360;
                    if (h < 0) continue;

                    var bIdx = Math.floor(h / 10) % 36;
                    var weight = pCol.hsvSaturation * pCol.hsvValue;
                    histogram[bIdx] += weight;

                    if (!sampleColors[bIdx] || weight > (sampleColors[bIdx].hsvSaturation * sampleColors[bIdx].hsvValue)) {
                        sampleColors[bIdx] = pCol;
                    }
                    vibrantFound = true;
                }
            }

            if (!vibrantFound) {
                var totalBrightness = 0;
                var pixelCount = imgData.length / 4;
                for (var k = 0; k < imgData.length; k += 4) {
                    var r_l = imgData[k] / 255;
                    var g_l = imgData[k+1] / 255;
                    var b_l = imgData[k+2] / 255;
                    totalBrightness += (0.299 * r_l + 0.587 * g_l + 0.114 * b_l);
                }
                var avgBrightness = totalBrightness / pixelCount;

                container.extractedAccent = avgBrightness < 0.5 ? "#D0D0D0" : "#404040";
                processed = true;
                return;
            }

            histogram[0] += histogram[35];

            var maxCount = -1;
            var winnerIdx = -1;
            for (var j = 0; j < 35; j++) {
                if (histogram[j] > maxCount) {
                    maxCount = histogram[j];
                    winnerIdx = j;
                }
            }

            if (winnerIdx !== -1 && sampleColors[winnerIdx]) {
                var finalColor = sampleColors[winnerIdx];
                var h = finalColor.hsvHue;
                var s = Math.max(0.35, Math.min(0.55, finalColor.hsvSaturation * 0.9));
                container.extractedAccent = Qt.hsva(h, s, 0.95, 1.0);
                processed = true;
            }
        }
    }

    Connections {
        target: backgroundImage
        function onStatusChanged() {
            if (backgroundImage.status === Image.Ready) {
                colorExtractor.processed = false;
                colorDelay.start();
            }
        }
    }

    FontLoader { id: fontRegular; source: "assets/fonts/FlexRounded-R.ttf" }
    FontLoader { id: fontMedium; source: "assets/fonts/FlexRounded-M.ttf" }
    FontLoader { id: fontBold; source: "assets/fonts/FlexRounded-B.ttf" }

    property var availableFonts: Qt.fontFamilies()
    property string activeFontRegular: (config.fontFamily && config.fontFamily.length > 0 && availableFonts.indexOf(config.fontFamily) >= 0) ? config.fontFamily : fontRegular.name
    property string activeFontBold:    (config.fontFamily && config.fontFamily.length > 0 && availableFonts.indexOf(config.fontFamily) >= 0) ? config.fontFamily : fontBold.name

    Image {
        id: backgroundImage
        source: config.background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    MultiEffect {
        id: backgroundBlur
        anchors.fill: parent
        source: backgroundImage
        blurEnabled: true
        blur: 1.0
        autoPaddingEnabled: false
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.5

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (container.passwordRevealed && passwordField.text === "") {
                    container.hidePassword();
                } else if (!container.passwordRevealed) {
                    container.revealPassword();
                }
            }
        }
    }

    PowerBar {
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 30
            rightMargin: 40
        }
        textColor: container.extractedAccent
        z: 100
        opacity: container.uiReady ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    Text {
        id: dateText
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        color: container.extractedAccent
        font.pixelSize: 22
        font.family: activeFontRegular
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 50
            leftMargin: 60
        }
        opacity: container.uiReady ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    // Clock no topo-centro (desaparece quando passwordRevealed = true)
    Item {
        id: clockTopArea
        visible: !container.passwordRevealed
        opacity: visible ? 1 : 0
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 48
        width: parent.width - 120
        height: mainClock.implicitHeight > 0 ? mainClock.implicitHeight : 120
        z: 5

        Behavior on opacity { NumberAnimation { duration: 220 } }

        Clock {
            id: mainClock
            anchors.centerIn: parent
            backgroundSource: config.background
            baseAccent: container.extractedAccent
            fontFamily: container.activeFontRegular
            opacity: container.uiReady ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }
        }
    }

    // Avatar + Username + Enter Password em baixo estilo macOS (desaparece quando passwordRevealed = true)
    ColumnLayout {
        id: userBlock
        visible: !container.passwordRevealed
        opacity: visible ? 1 : 0
        width: 420
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 72
        spacing: 8 // <--- ALTERA AQUI a distância entre avatar, username e Enter Password
        z: 10

        Behavior on opacity { NumberAnimation { duration: 220 } }

        Item {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 120
            Layout.alignment: Qt.AlignHCenter

            Rectangle {
                id: avatarFallback
                anchors.fill: parent
                color: surfaceColor
                radius: width / 2
                visible: avatar.status !== Image.Ready

                Text {
                    anchors.centerIn: parent
                    text: {
                        var n = "";
                        if (typeof userModel !== "undefined" && userModel.count > 0) {
                            var d = userModel.data(userModel.index(container.userIndex, 0), Qt.DisplayRole);
                            var nr = userModel.data(userModel.index(container.userIndex, 0), Qt.UserRole + 1);
                            n = d ? d.toString() : (nr ? nr.toString() : "U");
                        } else {
                            n = sddm.lastUser ? sddm.lastUser : "U";
                        }
                        return n.charAt(0);
                    }
                    color: container.extractedAccent
                    font.pixelSize: 48
                    font.family: activeFontBold
                    font.weight: Font.Bold
                }
            }

            Canvas {
                id: avatarCanvas
                anchors.fill: parent
                visible: avatar.status === Image.Ready

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.beginPath();
                    ctx.arc(width/2, height/2, width/2, 0, 2 * Math.PI);
                    ctx.closePath();
                    ctx.clip();
                    ctx.drawImage(avatar, 0, 0, width, height);
                }

                Timer {
                    id: repaintTimer
                    interval: 500
                    onTriggered: avatarCanvas.requestPaint()
                }

                Image {
                    id: avatar
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    visible: false

                    Component.onCompleted: {
                        var s = Qt.resolvedUrl("assets/avatar.jpg");
                        if (typeof userModel !== "undefined" && userModel.count > 0) {
                            var icon = userModel.data(userModel.index(container.userIndex, 0), Qt.UserRole + 3);
                            if (icon && icon.toString().match(/\.(jpg|jpeg|png|bmp|webp|svg)$/i)) {
                                s = icon.toString();
                            }
                        }
                        source = s;
                    }

                    onStatusChanged: {
                        if (status === Image.Ready) {
                            repaintTimer.start();
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: container.revealPassword()
            }
        }

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: userNameLabel.width + 24
            Layout.preferredHeight: userNameLabel.height

            Rectangle {
                anchors.fill: parent
                color: "white"
                opacity: userClickArea.pressed ? 0.2 : 0
                radius: 12
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            Text {
                id: userNameLabel
                anchors.centerIn: parent
                text: {
                    if (typeof userModel !== "undefined" && userModel.count > 0) {
                        var idx = container.userIndex;
                        var modelIdx = userModel.index(idx, 0);
                        var display = userModel.data(modelIdx, Qt.DisplayRole);
                        var edit = userModel.data(modelIdx, Qt.EditRole);
                        var nr = userModel.data(modelIdx, Qt.UserRole + 1);
                        var realName = userModel.data(modelIdx, Qt.UserRole + 2);
                        var finalName = display ? display.toString() : (realName ? realName.toString() : (nr ? nr.toString() : (edit ? edit.toString() : "User")));
                        return cleanName(finalName);
                    }
                    return cleanName(sddm.lastUser ? sddm.lastUser : "User");
                }
                color: "white"
                font.pixelSize: 24
                font.weight: Font.Bold
                font.family: activeFontRegular
            }

            MouseArea {
                id: userClickArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: container.revealPassword()
            }

            scale: userClickArea.pressed ? 0.95 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

	/*
        Button {
	    id: showPasswordButton
            visible: !container.passwordRevealed
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 30
            padding: 6
	    onClicked: container.revealPassword()

	    /*
            background: Rectangle {
                radius: 17
                color: showPasswordButton.pressed ? surfaceVariantColor : surfaceColor
                border.width: 1
                border.color: container.extractedAccent
            }

            contentItem: Text {
                text: "Enter Password"
                color: "gray"
                font.pixelSize: 14
                font.family: activeFontRegular
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
	*/
        Item {
            id: showPasswordTrigger
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: enterPasswordLabel.implicitWidth + 12
            Layout.preferredHeight: enterPasswordLabel.implicitHeight + 6

            Text {
                id: enterPasswordLabel
                anchors.centerIn: parent
                text: "Enter Password"
                color: "gray"
                opacity: enterPasswordMouseArea.pressed ? 0.5 : 0.85
                font.pixelSize: 14
                font.family: activeFontRegular
            }

            MouseArea {
                id: enterPasswordMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: container.revealPassword()
            }
        }
    }

    // Bloco central com Password Field + Sessões (aparece quando passwordRevealed = true)
    ColumnLayout {
        id: centerAuthBlock
        visible: container.passwordRevealed
        enabled: container.passwordRevealed
        opacity: visible ? 1 : 0
        width: 420
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 0
        spacing: 14
        z: 15

        Behavior on opacity { NumberAnimation { duration: 220 } }

        SequentialAnimation {
            id: shakeAnimation
            loops: 2
            NumberAnimation { target: centerAuthBlock; property: "anchors.horizontalCenterOffset"; to: -10; duration: 50; easing.type: Easing.InOutQuad }
            NumberAnimation { target: centerAuthBlock; property: "anchors.horizontalCenterOffset"; to: 10; duration: 50; easing.type: Easing.InOutQuad }
            NumberAnimation { target: centerAuthBlock; property: "anchors.horizontalCenterOffset"; to: 0; duration: 50; easing.type: Easing.InOutQuad }
        }

        // Nome do utilizador acima do campo de password (clicável para trocar utilizador se houver mais de 1)
        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: centerUserLabel.width + 28
            Layout.preferredHeight: centerUserLabel.height + 10

            Text {
                id: centerUserLabel
                anchors.centerIn: parent
                text: {
                    if (typeof userModel !== "undefined" && userModel.count > 0) {
                        var idx = container.userIndex;
                        var modelIdx = userModel.index(idx, 0);
                        var display = userModel.data(modelIdx, Qt.DisplayRole);
                        var edit = userModel.data(modelIdx, Qt.EditRole);
                        var nr = userModel.data(modelIdx, Qt.UserRole + 1);
                        var realName = userModel.data(modelIdx, Qt.UserRole + 2);
                        var finalName = display ? display.toString() : (realName ? realName.toString() : (nr ? nr.toString() : (edit ? edit.toString() : "User")));
                        return cleanName(finalName) + (userModel.count > 1 ? " ▾" : "");
                    }
                    return cleanName(sddm.lastUser ? sddm.lastUser : "User");
                }
                color: "white"
                font.pixelSize: 22
                font.weight: Font.Bold
                font.family: activeFontRegular
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: (typeof userModel !== "undefined" && userModel.count > 1) ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (typeof userModel !== "undefined" && userModel.count > 1) {
                        userPopup.open();
                    }
                }
            }
        }

        // Campo de password + botão redondo de login
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            Item {
                width: 48
                height: 1
            }

            TextField {
                id: passwordField
                echoMode: TextInput.Password
                Layout.preferredWidth: 260
                Layout.preferredHeight: 48
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "white"
                enabled: container.passwordRevealed && !container.isLoggingIn
                activeFocusOnTab: container.passwordRevealed

                background: Rectangle {
                    color: surfaceColor
                    radius: 16
                    border.width: parent.activeFocus ? 2 : 0
                    border.color: container.extractedAccent
                    opacity: parent.enabled ? 1.0 : 0.5
                }

                Text {
                    text: "Enter Password"
                    color: "gray"
                    font.pixelSize: 16
                    visible: !parent.text
                    anchors.centerIn: parent
                    opacity: 0.5
                }

                onAccepted: container.doLogin()
            }

            RoundButton {
                id: loginButton
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                focusPolicy: Qt.NoFocus
                enabled: container.passwordRevealed && !container.isLoggingIn

                contentItem: Text {
                    text: container.isLoggingIn ? "⋯" : "→"
                    color: "white"
                    font.pixelSize: 26
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: container.isLoggingIn ? surfaceVariantColor : (loginButton.pressed ? Qt.darker(container.extractedAccent, 1.1) : container.extractedAccent)
                    radius: 24
                    opacity: container.isLoggingIn ? 0.5 : 1.0
                }

                onClicked: container.doLogin()
            }
        }

        // Seletor de sessão (Hyprland, GNOME, etc.)
        Rectangle {
            id: sessionPill
            visible: typeof sessionModel !== "undefined" && sessionModel.count > 0
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 190
            Layout.preferredHeight: 36
            color: (sessionClickArea.pressed || sessionPopup.opened) ? surfaceVariantColor : surfaceColor
            radius: 18
            border.width: 1
            border.color: (sessionClickArea.pressed || sessionPopup.opened) ? container.extractedAccent : surfaceVariantColor

            scale: sessionClickArea.pressed ? 0.95 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }

            RowLayout {
                anchors.centerIn: parent
                spacing: 8
                Text {
                    text: "󰟀"
                    color: container.extractedAccent
                    font.pixelSize: 16
                }
                Text {
                    text: {
                        if (typeof sessionModel !== "undefined" && sessionModel.count > 0) {
                            var idx = container.sessionIndex;
                            var modelIdx = sessionModel.index(idx, 0);
                            var n = sessionModel.data(modelIdx, Qt.UserRole + 4);
                            var f = sessionModel.data(modelIdx, Qt.UserRole + 2);
                            var d = sessionModel.data(modelIdx, Qt.DisplayRole);
                            var finalName = n ? n.toString() : (f ? f.toString() : (d ? d.toString() : "Session " + (idx + 1)));
                            return cleanName(finalName) + (sessionModel.count > 1 ? " ▾" : "");
                        }
                        return "Hyprland";
                    }
                    color: "white"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }
            }

            MouseArea {
                id: sessionClickArea
                anchors.fill: parent
                onClicked: sessionPopup.open()
            }
        }

        Text {
            id: numLockIndicator
            text: "Num Lock is on"
            color: container.extractedAccent
            font.pixelSize: 14
            font.family: activeFontRegular
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignHCenter
            visible: {
                if (typeof keyboard !== "undefined" && typeof keyboard.numLock !== "undefined") return keyboard.numLock;
                return false;
            }
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }
    }

    Keys.onPressed: function(event) {
        if (!container.passwordRevealed && !userPopup.opened && !sessionPopup.opened) {
            if (event.key !== Qt.Key_Escape) {
                passwordField.text = "";
                container.revealPassword();
                event.accepted = true;
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: container.passwordRevealed && passwordField.text === "" && !userPopup.opened && !sessionPopup.opened
        onActivated: container.hidePassword()
    }

    Shortcut {
        sequences: ["Return", "Enter"]
        enabled: container.passwordRevealed && !userPopup.opened && !sessionPopup.opened
        onActivated: container.doLogin()
    }

    Popup {
        id: userPopup
        width: 260
        height: (typeof userModel !== "undefined") ? Math.min(300, userModel.count * 50 + 20) : 100
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2 - 50
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onOpened: userList.forceActiveFocus()
        onClosed: {
            if (container.passwordRevealed) passwordFocusTimer.restart();
            else refocusTimer.restart();
        }
        background: Rectangle {
            color: baseColor
            radius: 24
            opacity: 0.95
            border.color: surfaceVariantColor
            border.width: 1
        }
        enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
        exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 } }
        ListView {
            id: userList
            anchors.fill: parent
            anchors.margins: 10
            model: (typeof userModel !== "undefined") ? userModel : null
            spacing: 5
            clip: true
            focus: true
            currentIndex: container.userIndex
            highlightFollowsCurrentItem: true
            delegate: ItemDelegate {
                width: parent.width
                height: 40
                property bool isCurrent: index === userList.currentIndex
                background: Rectangle {
                    color: isCurrent ? surfaceVariantColor : (hovered ? surfaceColor : "transparent")
                    radius: 12
                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 8
                        width: 4
                        height: isCurrent ? 16 : 0
                        color: container.extractedAccent
                        radius: 2
                        Behavior on height { NumberAnimation { duration: 150 } }
                    }
                }
                contentItem: RowLayout {
                    anchors.fill: parent
                    spacing: 0
                    Item { Layout.preferredWidth: 20 }
                    Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        Layout.alignment: Qt.AlignVCenter
                        color: isCurrent ? container.extractedAccent : surfaceVariantColor
                        radius: 14
                        Text {
                            anchors.centerIn: parent
                            text: {
                                var mIdx = userModel.index(index, 0);
                                var d = userModel.data(mIdx, Qt.DisplayRole);
                                var n_r = userModel.data(mIdx, Qt.UserRole + 1);
                                var finalVal = d ? d.toString() : (n_r ? n_r.toString() : "U");
                                return finalVal.charAt(0);
                            }
                            color: isCurrent ? baseColor : "white"
                            font.pixelSize: 12
                            font.family: activeFontBold
                            font.weight: Font.Bold
                        }
                    }
                    Item { Layout.preferredWidth: 12 }
                    Text {
                        Layout.fillWidth: true
                        text: {
                            var mIdx = userModel.index(index, 0);
                            var d = userModel.data(mIdx, Qt.DisplayRole);
                            var n_r = userModel.data(mIdx, Qt.UserRole + 1);
                            var r = userModel.data(mIdx, Qt.UserRole + 2);
                            var e = userModel.data(mIdx, Qt.EditRole);
                            return cleanName(d ? d : (r ? r : (n_r ? n_r : e)));
                        }
                        color: isCurrent ? "white" : (hovered ? "#DDDDDD" : "#AAAAAA")
                        font.pixelSize: 15
                        font.family: activeFontRegular
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        rightPadding: 60
                        elide: Text.ElideRight
                    }
                }
                onClicked: {
                    container.userIndex = index;
                    userPopup.close();
                }
            }
            Keys.onDownPressed: incrementCurrentIndex()
            Keys.onUpPressed: decrementCurrentIndex()
            Keys.onReturnPressed: { container.userIndex = currentIndex; userPopup.close(); }
            Keys.onEnterPressed: { container.userIndex = currentIndex; userPopup.close(); }
        }
    }

    Popup {
        id: sessionPopup
        width: 260
        height: (typeof sessionModel !== "undefined") ? Math.min(250, sessionModel.count * 50 + 20) : 100
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2 + 60
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onOpened: sessionList.forceActiveFocus()
        onClosed: {
            if (container.passwordRevealed) passwordFocusTimer.restart();
            else refocusTimer.restart();
        }
        background: Rectangle {
            color: baseColor
            radius: 24
            opacity: 0.95
            border.color: surfaceVariantColor
            border.width: 1
        }
        enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
        exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 } }
        ListView {
            id: sessionList
            anchors.fill: parent
            anchors.margins: 10
            model: (typeof sessionModel !== "undefined") ? sessionModel : null
            spacing: 5
            clip: true
            focus: true
            currentIndex: container.sessionIndex
            highlightFollowsCurrentItem: true
            delegate: ItemDelegate {
                width: parent.width
                height: 40
                property bool isCurrent: index === sessionList.currentIndex
                background: Rectangle {
                    color: isCurrent ? surfaceVariantColor : (hovered ? surfaceColor : "transparent")
                    radius: 12
                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 8
                        width: 4
                        height: isCurrent ? 16 : 0
                        color: container.extractedAccent
                        radius: 2
                        Behavior on height { NumberAnimation { duration: 150 } }
                    }
                }
                contentItem: RowLayout {
                    anchors.fill: parent
                    spacing: 12
                    Item { Layout.preferredWidth: 16 }
                    Text {
                        Layout.fillWidth: true
                        text: {
                            var mIdx = sessionModel.index(index, 0);
                            var n = sessionModel.data(mIdx, Qt.UserRole + 4);
                            var d = sessionModel.data(mIdx, Qt.DisplayRole);
                            var f = sessionModel.data(mIdx, Qt.UserRole + 2);
                            return cleanName(n ? n : (d ? d : f));
                        }
                        color: isCurrent ? "white" : (hovered ? "#DDDDDD" : "#AAAAAA")
                        font.pixelSize: 15
                        font.family: isCurrent ? activeFontBold : activeFontRegular
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }
                onClicked: {
                    container.sessionIndex = index;
                    sessionPopup.close();
                }
            }
            Keys.onDownPressed: incrementCurrentIndex()
            Keys.onUpPressed: decrementCurrentIndex()
            Keys.onReturnPressed: { container.sessionIndex = currentIndex; sessionPopup.close(); }
            Keys.onEnterPressed: { container.sessionIndex = currentIndex; sessionPopup.close(); }
        }
    }
}
