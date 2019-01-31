import {weightedRand, randomProperty, randomNumber} from "./index.js";

export default class Producer{
    constructor(){
        this.type = "producer";
        this.produces;
        this.color;
        this.connected = false;
        this.connections = [[0 , 0 , 0 , 0 , 1 , 0 , 0, 0]];
        this.init();
    }
    init(){
        // Hmm.. 
    }
    pickColor(primary){
        // Not all producers make colours..
        let number = randomNumber(1, 0, 50, 0);
        if(number <= 25){
            this.color = randomProperty(primary);
            this.produces = true;
        } else {
            this.produces = false;
        }
    }
    
}