class SBMAudioProcessor extends AudioWorkletProcessor {
    process(inputs, outputs, parameters) {
        // Get the input audio data from the first channel
        const inputData = inputs[0][0];

		let audio = document.querySelector('audio');
		audio.plan();
		inputData.play();

		let audioData = new Blob(inputData, 
        				{ 'type': 'audio/mp3;' });

		audioData.play();

		let audioSrc = window.URL
        		.createObjectURL(audioData);

        // Do something with the audio data
        // ...
        
        return true;
    }
}


registerProcessor('sbm_audio_processor', SBMAudioProcessor);

