let recognition_ssn = new webkitSpeechRecognition() || new SpeechRecognition();
//let recognition_ssn = recognition;
recognition_ssn.continuous = true;

window.fun_stt_ssn = function fun_stt_ssn()
{
	fun_show(div_ssn);
	fun_speak(speak_ssn_header, speech_ssn);
	statusbox.value = speak_ssn_header + "\n";
	fun_set_start_button_ssn_core();
	
	if (userMediaFlag == true) {
		navigator.mediaDevices.getUserMedia({ audio: true })
		.then(stream => {
         
			audioRecorder_ssn = new MediaRecorder(stream);
            
			audioRecorder_ssn.addEventListener('dataavailable', e => {
				audioChunks_ssn.push(e.data);
			});
            
			fun_set_start_button_ssn();
			fun_set_stop_button_ssn();
			fun_set_next_button_ssn();
			fun_set_prev_button_ssn();
			fun_set_play_button_ssn();
		}).catch(err => {
			alert('Error: ' + err);
		});
	} else {
		fun_set_start_button_ssn();
		fun_set_stop_button_ssn();
		fun_set_next_button_ssn();
		fun_set_prev_button_ssn();
		fun_set_play_button_ssn();
	}

	recognition_ssn.addEventListener("result", (event) => {
    	const result = event.results[event.results.length - 1][0].transcript;
		let ssn = document.getElementById("ssn");
		let cmd = result.trim();
		if (cmd === "next") {
			fun_set_next_button_ssn_core();
		} else {
			ssn.value = ssn.value + result;
			statusbox.value = statusbox.value + result;
			//fun_show(statusbox);
		}
	});

	recognition_ssn.addEventListener("audioend", () => {
    	startButton_ssn.disabled = false;
		fun_hide(output_ssn);
	});
}

function fun_set_start_button_ssn_core()
{
	//window.speechSynthesis.cancel();
	fun_disable_button(startButton_ssn);
	//audioChunks_ssn = [];
	fun_show(output_ssn);
	output_ssn.innerHTML = 'Recording started for Patient SSN! Speak now. When you are done, Say "Next" or Press Next Button';

	if (userMediaFlag == true) {
		audioRecorder_ssn.start();
	}
	recognition_ssn.start();
}

function fun_set_start_button_ssn()
{
	startButton_ssn.addEventListener('click', () => {
		window.speechSynthesis.cancel();
		fun_set_start_button_ssn_core();
	});
}

function fun_set_stop_button_ssn_core()
{
	if (userMediaFlag == true) {
		audioRecorder_ssn.stop();
	}

	fun_enable_button(startButton_ssn);
	recognition_ssn.stop();
	window.speechSynthesis.cancel();
	fun_hide(output_ssn);
}

function fun_set_stop_button_ssn()
{
	stopButton_ssn.addEventListener('click', () => {
		fun_set_stop_button_ssn_core();
	});
}

function fun_set_next_button_ssn_core()
{
	fun_set_stop_button_ssn_core();
	if (singleFieldFlag == true) {
		fun_hide(div_ssn);
	}
	fun_stt_contactnum();
}

function fun_set_next_button_ssn()
{
	nextButton_ssn.addEventListener('click', () => {
		fun_set_next_button_ssn_core();
	});
}

function fun_set_prev_button_ssn()
{
	prevButton_ssn.addEventListener('click', () => {
		fun_set_stop_button_ssn_core();
		if (singleFieldFlag == true) {
			fun_hide(div_ssn);
		}
		fun_stt_dob();
	});
}

function fun_set_play_button_ssn()
{
	playButton_ssn.addEventListener('click', () => {
		if (userMediaFlag == true) {
			audioRecorder_ssn.stop();
			const blobObj = new Blob(audioChunks_ssn, { type: 'audio/webm' });
			const audioUrl = URL.createObjectURL(blobObj);
			const audio = new Audio(audioUrl);
			audio.play();
			output_ssn.innerHTML = '';
		}

		fun_enable_button(startButton_ssn);
		recognition_ssn.stop();
		window.speechSynthesis.cancel();
		fun_hide(output_ssn);

		ssn = document.getElementById("ssn").value;
		fun_speak(ssn, speech_ssn);
	});
}
