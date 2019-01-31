import "../style/style.scss";
import Pipe from "./pipe.js";
import Consumer from "./consumer.js";
import Producer from "./producer.js";



// Main game class i guess 
class PotionMaker {

    constructor(canvas) {
        this.fillButton = document.getElementById("flow-button");
        this.canvas = canvas;
        this.ctx = canvas.getContext("2d");
        this.canvas.width = this.canvas.offsetWidth;
        this.canvas.height = this.canvas.offsetHeight;
        this.w = this.canvas.width;
        this.h = this.canvas.height;
        this.cellS = 50;
        this.gridSize, this.colP, this.rowP, this.grid, this.hoverCell;
        this.mx, this.my = null;
        this.hoverCell = [];
        this.connectionList = [];
        this.primary = {
            red: '#990033',
            blue: '#0e4bef',
            yellow: '#fce903',
        };
        this.secondry = {
            purple: '#656731', // R + B
            green: '#49b675',  // B + Y 
            orange: '#fc9303', // R + Y 
            brown: '#1c74cd2', // All
        };
        this.activeColors = [];
         

        this.makeConnectionList();
        this.addListeners();
        this.start();
        this.makeGrid();
        this.flowPipes();
        this.loop();

    }

    fixActiveColors(){
        let clearArr = [...new Set(this.activeColors)];
        let newArr = [];
        console.log("Active colors: ", clearArr);
        for(let i in clearArr){
            for(let j = i; j < clearArr.length; j++){
                let combined = this.generateColor(new Set([clearArr[i], clearArr[j]]));
                if(combined !== this.secondry.brown){
                    newArr.push(combined);
                }
            }
        }
        console.log("Combined: ", newArr);
        
        clearArr = clearArr.concat(newArr);
        let cleanCombined = [...new Set(clearArr)];
        console.log("Final active colors: ", cleanCombined);
    }

    makeConnectionList() {
        //North can connect to south
        this.connectionList = [
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            []
        ];
        //North only connects to souths that are above
        this.connectionList[0].push([4, 'u']);
        //NE can only connect to SW if 
        this.connectionList[1].push([5, 'ur']);
        //E only conns with W if r
        this.connectionList[2].push([6, 'r']);
        //SE can connect with NW 
        this.connectionList[3].push([7, 'dr']);
        //S can connect to N if the north is below
        this.connectionList[4].push([0, 'd']);
        //SW can connect to NE
        this.connectionList[5].push([1, 'dl']);
        //W can connect to E
        this.connectionList[6].push([2, 'l']);
        //NW can connect to SE
        this.connectionList[7].push([3, 'ul']);
    }

    generateColor(colors){
        //Passed a set of hex codes with length > 1 (so we know there are at least 2 unique elements).
        let color = "#1c74cd2";
        if(colors.size == this.primary.length){
            //All colours in here once, return brown.
            color = this.secondry.brown;
        } else {
            // Combination of 2 colours.
            let possibleCombos = [
                new Set([this.primary.red, this.primary.blue]),
                new Set([this.primary.blue, this.primary.yellow]),
                new Set([this.primary.red, this.primary.yellow]),
            ];
            for(let i in possibleCombos){
                let possSet = possibleCombos[i];
                let equal = this.eqSet(possSet, colors);
                if(equal){
                    let scols = this.secondry;
                    color = scols[Object.keys(scols)[i]];
                }
            }
        }
        console.log("Generated Colours: ", color);
        return color;
    }

    eqSet(as, bs) {
        if (as.size !== bs.size) return false;
        for (var a of as) if (!bs.has(a)) return false;
        return true;
    }

    loop() {
        this.checkHover();
        this.clearGrid();
        this.drawGrid();
        window.requestAnimationFrame(this.loop.bind(this));
    }

    addListeners() {
        // Track the mouse across the canvas
        this.canvas.addEventListener("mousemove", function (ev) {
            let rect = this.canvas.getBoundingClientRect();
            this.mx = ev.clientX - rect.left;
            this.my = ev.clientY - rect.top;
        }.bind(this));
        this.canvas.addEventListener("mouseleave", function () {
            this.mx = null;
            this.my = null;
            this.hoverCell = null;
        }.bind(this));
        this.canvas.addEventListener("click", function () {
            this.checkClick();
        }.bind(this));
        //Flow button
        this.fillButton.addEventListener("click", function(){
            console.log("Fill button pressed");
        }.bind(this));
    }

    checkClick() {
        if (this.hoverCell != null && this.hoverCell.length == 2) {
            //We are hovering something - click it.
            let hov = this.hoverCell;
            let clickedCell = this.grid[hov[0]][hov[1]];
            clickedCell.pipe.rotate();
            this.flowPipes();
        }
    }

    flowPipes() {
        let grid = this.grid;
        let pipes = [];
        for (let i = 0; i < grid.length; i++) {
            for (let j = 0; j < grid[i].length; j++) {
                let cell = grid[i][j];
                if (cell.pipe || cell.consumer || cell.producer && cell.producer.produces) {
                    let pipe = cell.pipe || cell.consumer || cell.producer;
                    pipe.connected = false;
                    let surrounding = this.getSurrounding(pipe, i, j);
                    pipe.near = surrounding;
                    // Now we need to see which nearby pipes can connect with this pipe.
                    let connections = this.getConnections(pipe);
                    pipe.pipeConnections = connections[0];
                    pipe.indexConnections = connections[1];
                    pipes.push(pipe);
                }
            }
        }
        let paths = [];
        // Loop though all pipes and colour code the ones that connect
        for (let i in pipes) {
            let pipe = pipes[i];
            if (pipe.connected == false) {
                pipe.connected = true;
                // Get all pipes that connect to this pipe.
                let pipeConnections = this.getAllConnections(pipe);
                paths.push(pipeConnections);
            }
        }
        paths.sort(function (a, b) {
            return (b[0].length + b[1].length + b[2].length) - (a[0].length + a[1].length + a[2].length);
        });

        for (let i in paths) {
            let path = paths[i];
            let pipes = path[0];
            let consumers = path[1];
            let producers = path[2];

            if(producers.length > 0){
                //There are producers on the path. 
                let prodColors = new Set();
                let color = this.secondry.brown;
                for(let i in producers){
                    prodColors.add(producers[i].color);
                }
                if(prodColors.size > 1){
                    color = this.generateColor(prodColors);
                } else {
                    color = prodColors.values().next().value;
                }
                for(let i in pipes){
                    pipes[i].color = color;
                }
                for(let i in consumers){

                }
            } else {
                for(let i in pipes){
                    pipes[i].color = null;
                }
            }
        }
    }

    getSurrounding(pipe, row, col) {
        let surroundingPipes = [];
        //indexes for above, below, right, left, diag left up, diag left down, diag down right, diag up right
        let possilbeInd = [
            [row - 1, col, 'u'],
            [row + 1, col, 'd'],
            [row, col + 1, 'r'],
            [row, col - 1, 'l'],
            [row - 1, col - 1, 'ul'],
            [row + 1, col - 1, 'dl'],
            [row + 1, col + 1, 'dr'],
            [row - 1, col + 1, 'ur']
        ];

        for (let i in possilbeInd) {
            let pair = possilbeInd[i];
            let keysExist = this.testIndex(pair);
            let grid = this.grid;
            if (keysExist) {
                let cell = grid[pair[0]][pair[1]];
                if (cell.pipe != null) {
                    //Found a surrouding pipe, record pipe and direction to main
                    surroundingPipes.push([cell.pipe, pair[2], 0]);
                }
                if(cell.producer != null || cell.consumer != null){
                    if(cell.producer){
                        surroundingPipes.push([cell.producer, pair[2], 1]);
                    }
                    if(cell.consumer){
                        surroundingPipes.push([cell.consumer, pair[2], 2]);
                    }   
                }
            }
        }
        return surroundingPipes;
    }

    testIndex(pair) {
        //Tests if [i, j] exists in grid
        let row = pair[0];
        let col = pair[1];
        let grid = this.grid;
        let exists = false;
        if ((typeof grid[row]) !== "undefined") {
            if (typeof grid[row][col] !== "undefined") {
                exists = true;
            }
        }
        return exists;
    }

    getAllConnections(pipe) {
        //Given a pipe, list all of its connections, and their connections etc - forming a path of pipes.
        let path = [];
        let pipes = [];
        let producers = [];
        let consumers = [];
        let close = [];
        if(pipe.type == "pipe"){
            pipes.push(pipe);
        } else if(pipe.type == "producer"){
            producers.push(pipe);
        } else if(pipe.type == "consumer"){
            consumers.push(pipe);
        }

        let connections = pipe.pipeConnections;
        while (connections.length > 0) {
            let conn = connections.shift(); // Remove a pipe from the list.
            if (conn && conn.connected == false) {
                // This pipe is not connected already.
               
                if(conn.type == "pipe"){
                    pipes.push(conn);
                }else if(conn.type == "producer"){
                
                    producers.push(conn);
                } else if(conn.type == "consumer"){
                    
                    consumers.push(conn);
                }
                conn.connected = true;
                let moreConnections = conn.pipeConnections;
                connections = connections.concat(moreConnections);
            }
        }
        return [pipes, consumers, producers];
    }

    getConnections(pipe) {
        //This doesnt work correctly
        let pipeConnections = [];
        let indexConnections = [];
        let mainOpen = [];
        let subOpen = [];
        let mainConnections = pipe.connections;
        for (let i in mainConnections) {
            for (let j in mainConnections[i]) {
                if (mainConnections[i][j] !== 0) {
                    mainOpen.push(j);
                }
            }
        }

        let closePipes = pipe.near;
        for (let i in closePipes) {
            let close = closePipes[i];
            let cpipe = close[0];
            let dir = close[1];
            let type = close[2]; // 0 - pipe, 1 - producer, 2 - consumer
            let closeConn = cpipe.connections;
            if(type == 0 || (type == 1 && cpipe.produces == true) || type == 2){
                for (let j in closeConn) {
                    for (let k in closeConn[j]) {
                        if (closeConn[j][k] !== 0) {
                            subOpen.push([cpipe, k, dir]);
                        }
                    }
                }
            }
        }

        let possibleConnections = this.connectionList;
        for (let i in mainOpen) {
            let possible = possibleConnections[mainOpen[i]] || [];
            for (let j in subOpen) {
                let subPipe = subOpen[j][0];
                let subInd = subOpen[j][1];
                let subDir = subOpen[j][2];
                for (let k in possible) {
                    //Index and direction have to match
                    let poss = possible[k];
                    //mainopen[i] connects to subpipe if poss contains subind and 
                    if (subInd == poss[0] && subDir == poss[1]) {
                       
                        pipeConnections.push(subPipe);
                        indexConnections.push(mainOpen[i]);
                    }
                }
            }
        }
        return [pipeConnections, indexConnections];
    }

    checkMatches(pipe, sPipe) {
        //Check if any of the connections match up.
        let matches = [];
        let pconnections = [];
        let possible = this.connectionList;
        let main = pipe.connections;
        for (let i in main) {
            let connections = main[i];
            for (let j in connections) {
                if (connections[j] !== 0) {
                    //Pipe has opening at index j, that opening corresponds to a position
                    //Lookup all indexes j can connect to
                    let sub = sPipe.connections;
                    for (let k in sub) {
                        let subC = sub[k];
                        for (let l in subC) {
                            if (subC[l] !== 0) {
                                //Opening in other pipe, we can connect if l i in canConnect
                                if (possible[j].includes(parseInt(l))) {
                                    matches.push([j, l]); // Pipe connects to subpipe from j to l
                                    pconnections.push(sPipe);
                                }
                            }
                        }
                    }
                }
            }
        }
        return [matches, pconnections];
    }

    checkHover() {
        // Check if we are hovering over a cell
        let grid = this.grid;
        //This doesn't work because of the padding?
        for (let i = 0; i < grid.length; i++) {
            for (let j = 0; j < grid[i].length; j++) {
                let cell = grid[i][j];
                //Check if mouse is in cell
                if ((this.mx >= cell.x && this.mx <= cell.x + this.cellS) &&
                    (this.my >= cell.y && this.my <= cell.y + this.cellS)) {
                    // We are hovering a cell
                    //Store the index of the hover cell
                    this.hoverCell = [i, j];
                }
            }
        }
    }

    start() {
        // Cells will have the same width and height 
        let w = this.w;
        let h = this.h;
        let sz = this.cellS;
        let cols = Math.floor(w / sz);
        let rows = Math.floor(h / sz);
        //The grid has to have equal number of cols and rows. (pick the lowest)
        if (cols != rows) {
            if (cols < rows) {
                rows = cols;
            } else {
                rows = cols;
            }
        }
        //Padding for cols and rows
        let colP = w - (rows * sz);
        let rowP = h - (cols * sz);
        this.gridSize = cols;
        this.colP = colP;
        this.rowP = rowP
    }

    makeGrid() {
        //Make a grid 
        let grid = [];
        let y = this.rowP / 2;
        let ind = 0;
        for (let row = 0; row < this.gridSize; row++) {
            let x = this.colP / 2;
            let rw = [];
            for (let col = 0; col < this.gridSize; col++) {
                let cell = null;
                if (row == 0) {
                    let producer = new Producer();
                    producer.pickColor(this.primary, this.secondry);
                    if(producer.produces){
                        this.activeColors.push(producer.color);
                        this.fixActiveColors();
                    }
                    cell = {
                        x: x + (this.cellS * col),
                        y: y + (this.cellS * row),
                        size: this.cellS,
                        producer: producer,
                    }
                } else if (row == this.gridSize - 1) {
                    let consumer = new Consumer();
                    consumer.init();
                    consumer.pickColor(this.activeColors);
                    cell = {
                        x: x + (this.cellS * col),
                        y: y + (this.cellS * row),
                        size: this.cellS,
                        consumer: consumer
                    }
                } else {
                    let pipe = new Pipe(ind);
                    ind++;
                    pipe.pickConnections();
                    cell = {
                        x: x + (this.cellS * col),
                        y: y + (this.cellS * row),
                        size: this.cellS,
                        pipe: pipe
                    };
                }
                rw.push(cell);
            }
            grid.push(rw);
            
        }
        this.grid = grid;
       
    }

    clearGrid() {
        this.ctx.clearRect(0, 0, this.w, this.h);
    }

    drawGrid() {
        // Draws grid on canvas.
        let grid = this.grid;
        let ctx = this.ctx;
        let size = this.cellS;

        for (let i = 0; i < grid.length; i++) {
            for (let j = 0; j < grid[i].length; j++) {
                let cell = grid[i][j];
                ctx.beginPath();
                ctx.strokeRect(cell.x, cell.y, size, size);
                let hover = this.hoverCell;
                if (cell.pipe && cell.pipe.color != null) {
                    ctx.fillStyle = cell.pipe.color;
                    ctx.fillRect(cell.x, cell.y, size, size);
                }
                if(cell.consumer){
                    ctx.fillStyle = cell.consumer.color;
                    ctx.fillRect(cell.x, cell.y, cell.size, cell.size);
                    ctx.fillStyle = "white";
                    ctx.fillText(cell.consumer.level, cell.x + size / 2, cell.y + size / 2);
                }
                if(cell.producer){
                    ctx.fillStyle = cell.producer.color;
                    ctx.fillRect(cell.x, cell.y, size, size);
                    ctx.fillStyle = "white";
                    ctx.fillText("P", cell.x + size / 2, cell.y + size / 2);
                }
                if (hover != null && i == hover[0] && j == hover[1]) {
                    ctx.fillStyle = "orange";
                    ctx.fillRect(cell.x, cell.y, size, size);
                }

                ctx.closePath();
                if (cell.pipe) {
                    cell.pipe.drawPipe(ctx, cell);
                }
            }
        }
    }
}

//Returns x random directions
export function randomDirections(number) {
    let directions = [0, 1, 2, 3, 4, 5, 6, 7];
    let randomdirs = [];
    for (let i = 0; i < number; i++) {
        let index = Math.floor(Math.random() * directions.length);
        randomdirs.push(directions[index]);
        directions.splice(index, 1);
    }
    return randomdirs;
}

export function randomProperty(obj){
    // Given an object, return a random property.
    let keys = Object.keys(obj);
    return obj[keys[ keys.length * Math.random() << 0]];
}

export function randomNumber(number, min, max, signed) {
    // Generates {number} random numbers, between min and max, signed if provided.
    let numbers = [];
    let ok = true;
    while (ok) {
        numbers = [];
        //Generate {number} numbers.
        for (let i = 0; i < number; i++) {
            numbers.push(Math.round(Math.random() * (max - min) + min));
        }
        //if set length == arr length, all elements are unique
        let set = new Set(numbers);
        ok = set.size !== numbers.length;
    }
    if (numbers.length == 1) {
        return numbers[0];
    } else {
        return numbers;
    }
}

//Given an array of { val:perc, val1:perc1 }
export function weightedRand(spec) {
    var i, j, table = [];
    for (i in spec) {
        for (j = 0; j < spec[i] * 10; j++) {
            table.push(i);
        }
    }
    return table[Math.floor(Math.random() * table.length)];
}

var potionInst = null;
window.addEventListener("load", function () {
    let potionCanvas = document.getElementById("main-canvas");
    potionInst = new PotionMaker(potionCanvas);
    potionInst.drawGrid();
});