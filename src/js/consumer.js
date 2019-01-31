import {weightedRand, randomProperty, randomNumber} from "./index.js";

export default class Consumer {
    constructor() {
        this.type = "consumer";
        this.baseChance = {1:0.5, 2:0.2, 3:0.2, 4:0.1};
        this.chance = this.baseChance;
        this.level, this.color, this.value = null;
        this.connected = false;
        this.connections = [[1 , 0 , 0 , 0 , 0 , 0 , 0, 0]];
        this.init();
    }

    init() {
        /* 
        Pick level, colors and value
        value depends on color and level
        */
        // TODO: Currently not managing current, will pass 0 for now 
       this.pickLevel(0);
    }

    increaseDiff() {
        /* 
        0 and 1 decrese 
        2 and 3 increase
        */
        if (this.chance[0] > 0) {
            this.chance[0] -= 0.05;
        }
        if (this.chance[1] > 0) {
            this.chance[1] -= 0.05;
        }
        if (this.chance[2] < 0.5) {
            this.chance[2] += 0.05;
        }
        if (this.chance[3] < 0.5) {
            this.chance[3] += 0.05;
        }
    }

    decreaseDiff() {
        /* 
        0 and 1 increase
        2 and 3 decrease 
        */
        if (this.chance[0] < 0.5) {
            this.chance[0] += 0.05;
        }
        if (this.chance[1] < 0.5) {
            this.chance[1] += 0.05;
        }
        if (this.chance[2] > 0) {
            this.chance[2] -= 0.05;
        }
        if (this.chance[3] > 0) {
            this.chance[3] -= 0.05;
        }
    }

    pickLevel(current) {
        /* Adjust chances by current? 
        
        0 - down as current inc
        2 - down (slow) as current inc
        3 - up (slow) as current inc
        4 - up fastish
        */
        if (current < 0) {
            //Decrease difficulty
            this.decreaseDiff();

        } else if (current > 0) {
            //Increase difficulty
            this.increaseDiff();
        }
        this.level = weightedRand(this.chance);
        console.log("Random Level: ", this.level);
        // Higer current values lead to higher levels (and potentially more value)
    }

    pickColor(primary, secondry){
        let colType = randomNumber(1, 1, 2, 0);
        console.log("COL TYPE: ", colType);
        if(colType == 1){
            //Prime
            this.color = randomProperty(primary);
        } else if(colType == 2){
            //Second
            this.color = randomProperty(secondry);
        }
        // We should only pick colours that the producers can make 
        // TODO: some reference to producers.
        // For now, we will just rando pick a colour.
        // Given 2 objects of colours
    }
}



