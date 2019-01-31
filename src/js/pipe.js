import {randomDirections, randomNumber} from "./index.js";

export default class Pipe{
    constructor(ind){
        this.type = "pipe";
        this.connected = false;
        this.id = ind;
        this.connections = [];
        this.near = [];
        this.pipeConnections  = [];
        this.indexConnections = [];
        this.color = null;
    }

    rotate(){
        //Not sure how to rotate the directions as objects 
        for(let i in this.connections){
            let connection = this.connections[i];
            let last = connection.pop();
            connection.unshift(last);
        }
    }

    drawPipe(ctx, cell){
        //Not sure how this should work
        /* 
            --------
           |NW  N  NE| 
           |W       E|
           |SW  S  SE|
            --------
        */
        let debw = 8;
        let coords = [
             {x: (cell.x + cell.size / 2) - debw/2, y: cell.y}, // NORTH
             {x: cell.x + cell.size - debw, y: cell.y}, // NE
             {x: cell.x + cell.size - debw, y: cell.y + cell.size / 2 - debw / 2}, // E
             {x: cell.x + cell.size - debw, y: cell.y + cell.size - debw}, // SE
             {x: (cell.x + cell.size / 2) - debw / 2, y: cell.y + cell.size - debw}, // S
             {x: cell.x, y: cell.y + cell.size - debw}, // SW 
             {x: cell.x, y: cell.y + cell.size / 2 - debw / 2}, // W
             {x: cell.x, y: cell.y}// NW
        ];

        for(let i = 0; i < this.connections.length; i++){
            let connection = this.connections[i];
            for(let key in connection){
                if(connection[key] !== 0){
                    if(this.indexConnections.includes(key)){
                        ctx.fillStyle = "Purple";
                    } else {
                        ctx.fillStyle = "Red";
                    }
                    ctx.fillRect(coords[key].x, coords[key].y, debw, debw);

                    //Draw a line from the point to the center of the cell
                    ctx.beginPath();
                    ctx.moveTo(coords[key].x + debw / 2, coords[key].y + debw / 2);
                    ctx.lineTo(cell.x + cell.size/2, cell.y + cell.size/2);
                    ctx.stroke();
                }
            }
        }
    }


    pickConnections(){
        /* 
        Pipes with crossover should probs only appear on higher difficulties - will be left till later
        Essentiall need to generate an array with 8 elements, at least 1 of them is a 1 and 2, others can be whatever
        */
        let inputs = 0;
        let outputs = 0;
        //Pick our first inputs and outputs? 
        let startDir = randomDirections(2);
        //                N   NE  E   SE  S   SW  W  NW 
        let connection = [0 , 0 , 0 , 0 , 0 , 0 , 0, 0];
        for(let i in startDir){
            connection[startDir[i]] = 1;
        }


        //Add additional random connections     
        for(let i in connection){
            if(connection[i] == 0){
                let random = randomNumber(1, 0, 50, 0);
                if(random <= 5){
                    connection[i] = 1;
                }
            }
        }
     
        this.connections.push(connection);
    }

}