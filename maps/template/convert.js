const fs = require('fs');

fs.readFile('template.json', function(err, data) {
	//loading/parse file
	if (err) {
		console.log("file could not be open");
		return;
	}
	let fileData = JSON.parse(data)
	
	//find tile map
	let tileMapId = -1;
	for(let i = 0; i < fileData.layers.length; ++i){
		if (fileData.layers[i].id === 1){ //1 is tile map id
			tileMapId = i;
			break;
		}
	}
	if (tileMapId === -1){
		console.log("count not find ID 1 'TileMap'");
		return;
	}
	
	//remove the +1 offse
	//and keep in 128 range (0-127)
	for(let i = 0; i < fileData.layers[tileMapId].data.length; ++i){
		fileData.layers[tileMapId].data[i] = Math.max((fileData.layers[tileMapId].data[i] - 1) % 128, 0);
	}
	
	//find wall map
	let wallMapId = -1;
	for(let i = 0; i < fileData.layers.length; ++i){
		if (fileData.layers[i].id === 2){ //2 is WallMap id
			wallMapId = i;
			break;
		}
	}
	if (wallMapId === -1){
		console.log("count not find ID 1 'WallMap'");
		return;
	}
	
	//set wall in tile map by adding 128 (setting high bit)
	//if the wall map has a value != 0
	for(let i = 0; i < fileData.layers[tileMapId].data.length; ++i){
		if (fileData.layers[wallMapId].data[i] !== 0)
			fileData.layers[tileMapId].data[i] += 128;
	}
	
	//make the out file data
	let outFile = "DB "
	for(let i = 0; i < fileData.layers[tileMapId].data.length; ++i){
		outFile += fileData.layers[tileMapId].data[i].toString().padStart(3, '0');
		if ((i + 1) < fileData.layers[tileMapId].data.length){
			if ( (i + 1) % 120 === 0 )
				outFile += '\nDB ';
			else
				outFile += ", ";
		}
	}
	
	//save
	fs.writeFile('MapOut.asm', outFile, function (err) {
		if (err) {
			console.log("file count not be saved");
			return;
		}
		
		console.log('Saved!');
	});
	
	//end
});