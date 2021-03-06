.pragma library

// This script is a library. This improves performance, but it means that no
// variables from the outside can be accessed.


var DEVELOPMENT = [
    {label: qsTr("Programming"), values: ["Mirian Margiani"]},
    {label: qsTr("Icon Design"), values: ["Mirian Margiani"]}
]

var TRANSLATIONS = [
    {label: qsTr("English"), values: ["Mirian Margiani"]},
    {label: qsTr("German"), values: ["Mirian Margiani"]}
]

var VERSION_NUMBER // set in main.qml's Component.onCompleted
var APPINFO = {
    appName: qsTr("Todo List"),
    iconPath: "../images/harbour-todolist.png",
    description: qsTr("A simple tool for planning what to do next."),
    author: "Mirian Margiani",
    dataInformation: "",  // if your app uses data from an external provider, add e.g. copyright
                          // info here
    dataLink: "",         // a link to the website of an external provider
    dataLinkText: "",     // custom button text
    sourcesLink: "https://github.com/ichthyosaurus/harbour-todolist",
    sourcesText: qsTr("Sources on GitHub"),

    enableContributorsPage: false, // whether to enable 'ContributorsPage.qml'
    contribDevelopment: DEVELOPMENT,
    contribTranslations: TRANSLATIONS
}

function aboutPageUrl() {
    return Qt.resolvedUrl("AboutPage.qml");
}

function pushAboutPage(pageStack) {
    APPINFO.versionNumber = VERSION_NUMBER;
    pageStack.push(aboutPageUrl(), APPINFO);
}
