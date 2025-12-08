const Ensemble = require("../ensemble/ensemble/ensemble.js");

let characters = Ensemble.socialStructure.getCharacters();

console.log("Loaded CiF characters:");
console.log(characters);

let alice = Ensemble.socialStructure.getCharacterByName("Alice");
console.log("Example CiF Agent:", alice);
