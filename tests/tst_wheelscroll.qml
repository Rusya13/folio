import QtQuick
import QtTest
import "../src"

// The file views aren't interactive, so a Flickable ignores the wheel by
// itself: WheelScroll is what scrolls them.
Item {
    width: 600; height: 200

    ListView {
        id: bare
        width: 200; height: 200
        interactive: false
        model: 100
        delegate: Rectangle { width: 200; height: 30 }
    }

    ListView {
        id: list
        x: 200; width: 200; height: 200
        interactive: false
        model: 100
        delegate: Rectangle { width: 200; height: 30 }
        WheelScroll { view: list }
    }

    Flickable {
        id: across
        x: 400; width: 200; height: 200
        interactive: false
        contentWidth: 1000; contentHeight: 200
        WheelScroll { view: across; orientation: Qt.Horizontal }
    }

    TestCase {
        name: "WheelScroll"
        when: windowShown

        function init() { bare.contentY = 0; list.contentY = 0; across.contentX = 0 }

        function test_withoutItTheWheelDoesNothing() {
            mouseWheel(bare, 100, 100, 0, -120)
            compare(bare.contentY, 0)
        }

        function test_wheelScrollsDownAndBack() {
            mouseWheel(list, 100, 100, 0, -120)
            verify(list.contentY > 0, "contentY " + list.contentY)
            mouseWheel(list, 100, 100, 0, 120)
            compare(list.contentY, 0)
        }

        function test_staysWithinTheContent() {
            for (let i = 0; i < 200; ++i)
                mouseWheel(list, 100, 100, 0, -120)
            compare(list.contentY, list.contentHeight - list.height)
            for (let i = 0; i < 200; ++i)
                mouseWheel(list, 100, 100, 0, 120)
            compare(list.contentY, 0)
        }

        function test_sidewaysScrollsTheColumns() {
            mouseWheel(across, 100, 100, -120, 0)
            verify(across.contentX > 0, "contentX " + across.contentX)
        }
    }
}
