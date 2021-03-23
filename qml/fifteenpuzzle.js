.import QtQuick 2.12 as Quick

var boardSize;
var maxIndex = 0;
var empty;
var cell;
var component;

//Index function used instead of a 2D array
function index(column, row) {
    return column + (row * boardSize);
}

function createBoard() {

    if (maxIndex === 0) { // call only once

        boardSize = mainWindow.boardSize
        maxIndex = boardSize * boardSize;
        empty = maxIndex - 1

        cell = new Array(maxIndex);
        for(var idx = 0; idx < maxIndex; idx++) {
            cell[idx] = null;
            _createCell(idx);
        }

    }
}

function _createCell(idx) {
    if (component === undefined)
        component = Qt.createComponent('Cell.qml');

    // Note that if Cell.qml was not a local file, component.status would be
    // Loading and we should wait for the component's statusChanged() signal to
    // know when the file is downloaded and ready before calling createObject().
    if (component.status === Quick.Component.Ready) {

        var dynamicObject = component.createObject(boardCanvas);
        if (dynamicObject === null) {
            console.log('error creatingCell');
            console.log(component.errorString());
            return false;
        }
        cell[idx] = dynamicObject;

        dynamicObject.idx = idx
        dynamicObject.value = idx

        dynamicObject.clicked.connect(cellClicked)

    } else {
        console.log('error loading Cell component');
        console.log(component.errorString());
        return false;
    }
    return true;
}

function cellClicked(idx) {
    var c = cell[idx]
    var cidx = c.idx
    var e = cell[empty]

    var direction, ri, ci, oldIdx, newIdx

    if (c.column === e.column) {
        direction = (e.row - c.row) > 0 ? +1 : -1; // +1 bottom -1 up

        if (direction === +1) {
            // Move bottom
            for( ri=e.row - direction; ri >= c.row; ri--) {
                //console.log('ri', ri)
                oldIdx  = index(c.column, ri)
                newIdx = index(c.column, ri + direction)
                cell[newIdx] = cell[oldIdx]
                cell[newIdx].moveTo(newIdx)
            }
        } else {
            // Move up
            for( ri=e.row - direction; ri <= c.row; ri++) {
                //console.log('ri', ri)
                oldIdx  = index(c.column, ri)
                newIdx = index(c.column, ri + direction)
                cell[newIdx] = cell[oldIdx]
                cell[newIdx].moveTo(newIdx)
            }
        }

        empty = cidx
        cell[cidx] = e
        e.moveTo(cidx)
        _checkVictory()

    } else if (c.row === e.row) {
        direction = (e.column - c.column) > 0 ? +1 : -1; // +1 right -1 left

        if (direction === +1) {
            // Move right
            for( ci=e.column - direction; ci >= c.column; ci--) {
                //console.log('ci', ci)
                oldIdx  = index(ci, c.row)
                newIdx = index(ci + direction, c.row)
                cell[newIdx] = cell[oldIdx]
                cell[newIdx].moveTo(newIdx)
            }
        } else {
            // Move left
            for( ci=e.column - direction; ci <= c.column; ci++) {
                //console.log('ci', ci)
                oldIdx  = index(ci, c.row)
                newIdx = index(ci + direction, c.row)
                cell[newIdx] = cell[oldIdx]
                cell[newIdx].moveTo(newIdx)
            }
        }

        empty = cidx
        cell[cidx] = e
        e.moveTo(cidx)
        _checkVictory()

        //console.log('[ ' + cell[index(0, 3)].value + ' ' + cell[index(1, 3)].value + ' ' + cell[index(2, 3)].value + ' ' + cell[index(3, 3)].value + ']')
    }

}

function _checkVictory() {
    for(var i=0; i<cell.length; i++) {
        if (cell[i].idx !== cell[i].value) {
            return
        }
    }

    // If I'm here I won !
    victoryDialog.show()
}

function shuffle() {
    curtain.hide();
    var arr = _fisher_yates()
    var isSolvable = _isSolvable(arr);
    if (!isSolvable) {
        var t = arr[0]
        arr[0] = arr[1]
        arr[1] = t
    }

    // Set the board
    for(var i = 0; i < maxIndex - 1; i++) {
        cell[i].value = arr[i]
    }

    empty = maxIndex - 1
    cell[empty].value = maxIndex - 1
}

function _isSolvable(arr) {
    // Count the inversions of the puzzle
    var inversions = 0;
    for(var i = 0; i < arr.length; i++) {
        for(var j = i + 1; j < arr.length; j++) {
            if (arr[i] > arr[j]) {
                inversions++;
            }
        }
    }

    return (inversions % 2 == 0)
}

function _fisher_yates() {

    var array = new Array(maxIndex - 1);
    for(var i = 0; i < array.length; i++) {
        array[i]= i
    }

    for (i = array.length - 1; i > 0; i -= 1) {
        var j = Math.floor(Math.random() * (i + 1))
        var temp = array[i]
        array[i] = array[j]
        array[j] = temp
    }

    return array;
}


