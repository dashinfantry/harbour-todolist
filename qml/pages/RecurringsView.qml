import QtQuick 2.0
import Sailfish.Silica 1.0
import SortFilterProxyModel 0.2
import "../components"
import "../js/helpers.js" as Helpers
import "../constants" 1.0

SilicaListView {
    id: view
    model: filteredModel
    VerticalScrollDecorator { flickable: view }
    property int showFakeNavigation: FakeNavigation.None

    SortFilterProxyModel {
        id: filteredModel
        sourceModel: recurringsModel

        sorters: [
            RoleSorter { roleName: "entryState"; sortOrder: Qt.AscendingOrder },
            RoleSorter { roleName: "intervalDays"; sortOrder: Qt.DescendingOrder },
            RoleSorter { roleName: "startDate"; sortOrder: Qt.AscendingOrder }
        ]
    }

    header: FakeNavigationHeader {
        title: qsTr("Recurring Entries")
        description: currentProjectName
        showNavigation: showFakeNavigation
    }

    PullDownMenu {
        MenuItem {
            text: qsTr("Add recurring entry")
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("AddRecurringDialog.qml"))
                dialog.accepted.connect(function() {
                    main.addRecurring(dialog.text.trim(), dialog.description.trim(), dialog.intervalDays, dialog.startDate);

                    console.log(dialog.startDate, today)
                    if (Helpers.getDate(0, dialog.startDate).getTime() === today.getTime()) {
                        main.addItem(today, dialog.text.trim(), dialog.description.trim(),
                                     EntryState.todo, EntrySubState.today, today, dialog.intervalDays);
                        console.log("add")
                    }
                });
            }
        }
    }

    footer: Spacer { }

    delegate: TodoListBaseItem {
        editable: true
        descriptionEnabled: true
        infoMarkerEnabled: false
        title: model.text
        description: model.description

        onMarkItemAs: main.updateRecurring(view.model.mapToSource(which), undefined, mainState);
        onSaveItemTexts: main.updateRecurring(view.model.mapToSource(which), undefined, undefined, undefined, newText, newDescription);
        onDeleteThisItem: main.deleteRecurring(view.model.mapToSource(which))
        extraDeleteWarning: qsTr("This will <i>not</i> delete entries retroactively.")

        menu: Component {
            ContextMenu {
                MenuItem {
                    visible: entryState !== EntryState.todo
                    text: qsTr("mark as active")
                    onClicked: markItemAs(index, EntryState.todo, undefined)
                }
                MenuItem {
                    visible: entryState !== EntryState.ignored
                    text: qsTr("mark as halted")
                    onClicked: markItemAs(index, EntryState.ignored, undefined)
                }
                MenuItem {
                    visible: entryState !== EntryState.done
                    text: qsTr("mark as done")
                    onClicked: markItemAs(index, EntryState.done, undefined)
                }
            }
        }
    }

    section {
        property: 'entryState'
        delegate: Spacer { }
    }

    ViewPlaceholder {
        enabled: view.count == 0 && startupComplete
        text: qsTr("No entries yet")
        hintText: qsTr("This page will show a list of all recurring entries.")
    }
}
