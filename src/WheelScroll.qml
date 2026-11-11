import QtQuick

// Scrolls the view it sits in with the mouse wheel and the touchpad. The
// file views aren't interactive, so pressing and dragging picks up a file
// instead of flicking, and a Flickable that isn't interactive ignores the
// wheel too: this puts the wheel back.
WheelHandler {
    id: wheel
    target: null

    // Given by name: inside a Flickable this handler lands on its content
    // item, not on the Flickable itself.
    required property Flickable view

    onWheel: (event) => {
        const view = wheel.view
        const across = wheel.orientation === Qt.Horizontal
        // Touchpads say how far in pixels; wheels in eighths of a degree,
        // 120 to a notch, which moves a few lines like everywhere else.
        const pixels = across ? event.pixelDelta.x : event.pixelDelta.y
        const notches = (across ? event.angleDelta.x : event.angleDelta.y) / 120
        const delta = pixels !== 0 ? pixels : notches * Qt.styleHints.wheelScrollLines * 20
        if (across) {
            const last = view.originX + view.contentWidth - view.width
            view.contentX = Math.max(view.originX, Math.min(last, view.contentX - delta))
        } else {
            const last = view.originY + view.contentHeight - view.height
            view.contentY = Math.max(view.originY, Math.min(last, view.contentY - delta))
        }
    }
}
