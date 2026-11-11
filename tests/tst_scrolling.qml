import QtQuick
import QtTest

// The file views take mouse drags for picking up files, so they don't flick
// with the mouse (acceptedButtons: Qt.NoButton) but must still scroll with
// the wheel and touchpad. interactive: false would stop the wheel too.
Item {
    width: 400; height: 200

    ListView {
        id: off
        width: 200; height: 200
        interactive: false
        model: 100
        delegate: Rectangle { width: 200; height: 30 }
    }

    ListView {
        id: list
        x: 200; width: 200; height: 200
        acceptedButtons: Qt.NoButton
        boundsBehavior: Flickable.StopAtBounds
        model: 100
        delegate: Rectangle { width: 200; height: 30 }
    }

    TestCase {
        name: "Scrolling"
        when: windowShown

        function init() { off.contentY = 0; list.cancelFlick(); list.contentY = 0 }

        function test_interactiveFalseStopsTheWheel() {
            mouseWheel(off, 100, 100, 0, -120)
            wait(50)
            compare(off.contentY, 0)
        }

        function test_wheelScrolls() {
            mouseWheel(list, 100, 100, 0, -120)
            tryVerify(() => list.contentY > 0, 1000, "contentY " + list.contentY)
        }

        function test_mouseDragDoesNotScroll() {
            mousePress(list, 100, 150)
            for (let y = 140; y >= 20; y -= 10)
                mouseMove(list, 100, y)
            mouseRelease(list, 100, 20)
            wait(100)
            compare(list.contentY, 0)
            verify(!list.moving)
        }
    }
}
