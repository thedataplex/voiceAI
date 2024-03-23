let recognition_dob = new webkitSpeechRecognition() || new SpeechRecognition();
//let recognition_dob = recognition;
recognition_dob.continuous = true;

window.fun_stt_dob = function fun_stt_dob()
{
	fun_show(div_dob);
	fun_speak(speak_dob_header, speech_dob);
	statusbox.value = speak_dob_header + "\n";
	fun_set_start_button_dob_core();
	
	if (userMediaFlag == true) {
		navigator.mediaDevices.getUserMedia({ audio: true })
		.then(stream => {
         
			audioRecorder_dob = new MediaRecorder(stream);
            
			audioRecorder_dob.addEventListener('dataavailable', e => {
				audioChunks_dob.push(e.data);
			});
            
			fun_set_start_button_dob();
			fun_set_stop_button_dob();
			fun_set_next_button_dob();
			fun_set_prev_button_dob();
			fun_set_play_button_dob();
		}).catch(err => {
			alert('Error: ' + err);
		});
	} else {
		fun_set_start_button_dob();
		fun_set_stop_button_dob();
		fun_set_next_button_dob();
		fun_set_prev_button_dob();
		fun_set_play_button_dob();
	}

	recognition_dob.addEventListener("result", (event) => {
    	const result = event.results[event.results.length - 1][0].transcript;
		let dob = document.getElementById("dob");
		let cmd = result.trim();
		if (cmd === "next") {
			fun_set_next_button_dob_core();
		} else {
			dob.value = dob.value + result;
			statusbox.value = statusbox.value + result;
		}
		//fun_show(statusbox);
	});

	recognition_dob.addEventListener("audioend", () => {
    	startButton_dob.disabled = false;
		fun_hide(output_dob);
	});
}

function fun_set_start_button_dob_core()
{
	//window.speechSynthesis.cancel();
	fun_disable_button(startButton_dob);
	//audioChunks_dob = [];
	fun_show(output_dob);
	output_dob.innerHTML = 'Recording started for Patient Date of Birth! Speak now. When you are done, Say "Next" or Press Next Button';
	recognition_dob.start();

	if (userMediaFlag == true) {
		audioRecorder_dob.start();
	}
}

function fun_set_start_button_dob()
{
	startButton_dob.addEventListener('click', () => {
		window.speechSynthesis.cancel();
		fun_set_start_button_dob_core();
	});
}

function fun_set_stop_button_dob_core()
{
	if (userMediaFlag == true) {
		audioRecorder_dob.stop();
	}

	fun_enable_button(startButton_dob);
	recognition_dob.stop();
	window.speechSynthesis.cancel();
	fun_hide(output_dob);
}

function fun_set_stop_button_dob()
{
	stopButton_dob.addEventListener('click', () => {
		fun_set_stop_button_dob_core();
	});
}

function fun_set_next_button_dob_core()
{
	fun_set_stop_button_dob_core();
	if (singleFieldFlag == true) {
		fun_hide(div_dob);
	}
	fun_stt_ssn();
}

function fun_set_next_button_dob()
{
	nextButton_dob.addEventListener('click', () => {
		fun_set_next_button_dob_core();
	});
}

function fun_set_prev_button_dob()
{
	prevButton_dob.addEventListener('click', () => {
		fun_set_stop_button_dob_core();
		if (singleFieldFlag == true) {
			fun_hide(div_dob);
		}
		fun_stt_name();
	});
}

function fun_set_play_button_dob()
{
	playButton_dob.addEventListener('click', () => {
		if (userMediaFlag == true) {
			audioRecorder_dob.stop();
			const blobObj = new Blob(audioChunks_dob, { type: 'audio/webm' });
			const audioUrl = URL.createObjectURL(blobObj);
			const audio = new Audio(audioUrl);
			audio.play();
			output_dob.innerHTML = '';
		}

		fun_enable_button(startButton_dob);
		recognition_dob.stop();
		window.speechSynthesis.cancel();
		fun_hide(output_dob);

		dob = document.getElementById("dob").value;
		fun_speak(dob, speech_dob);
	});
}
