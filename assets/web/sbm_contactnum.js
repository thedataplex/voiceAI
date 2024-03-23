let recognition_contactnum = new webkitSpeechRecognition() || new SpeechRecognition();
//let recognition_contactnum = recognition;

recognition_contactnum.continuous = true;

window.fun_stt_contactnum = function fun_stt_contactnum()
{
	fun_show(div_contactnum);
	fun_speak(speak_contactnum_header, speech_contactnum);
	statusbox.value = speak_contactnum_header + "\n";
	fun_set_start_button_contactnum_core();
	
	if (userMediaFlag == true) {
		navigator.mediaDevices.getUserMedia({ audio: true })
		.then(stream => {
         
			audioRecorder_contactnum = new MediaRecorder(stream);
            
			audioRecorder_contactnum.addEventListener('dataavailable', e => {
				audioChunks_contactnum.push(e.data);
			});
            
			fun_set_start_button_contactnum();
			fun_set_stop_button_contactnum();
			fun_set_next_button_contactnum();
			fun_set_prev_button_contactnum();
			fun_set_play_button_contactnum();
		}).catch(err => {
			alert('Error: ' + err);
		});
	} else {
		fun_set_start_button_contactnum();
		fun_set_stop_button_contactnum();
		fun_set_next_button_contactnum();
		fun_set_prev_button_contactnum();
		fun_set_play_button_contactnum();
	}

	recognition_contactnum.addEventListener("result", (event) => {
    	const result = event.results[event.results.length - 1][0].transcript;
		let contactnum = document.getElementById("contactnum");
		let cmd = result.trim();
		if (cmd === "next") {
			fun_set_next_button_contactnum_core();
		} else {
			contactnum.value = contactnum.value + result;
			statusbox.value = statusbox.value + result;
		}
		//fun_show(statusbox);
	});

	recognition_contactnum.addEventListener("audioend", () => {
    	startButton_contactnum.disabled = false;
		fun_hide(output_contactnum);
	});
}

function fun_set_start_button_contactnum_core()
{
	//window.speechSynthesis.cancel();
	fun_disable_button(startButton_contactnum);
	//audioChunks_contactnum = [];
	fun_show(output_contactnum);
	output_contactnum.innerHTML = 'Recording started for Patient Mobile Number! Speak now. When you are done, Say "Next" or Press Next Button';

	if (userMediaFlag == true) {
		audioRecorder_contactnum.start();
	}

	recognition_contactnum.start();
}

function fun_set_start_button_contactnum()
{
	startButton_contactnum.addEventListener('click', () => {
		window.speechSynthesis.cancel();
		fun_set_start_button_contactnum_core();
	});
}

function fun_set_stop_button_contactnum_core()
{
	if (userMediaFlag == true) {
		audioRecorder_contactnum.stop();
	}

	fun_enable_button(startButton_contactnum);
	recognition_contactnum.stop();
	window.speechSynthesis.cancel();
	fun_hide(output_contactnum);
}

function fun_set_stop_button_contactnum()
{
	stopButton_contactnum.addEventListener('click', () => {
		fun_set_stop_button_contactnum_core();
	});
}

function fun_set_next_button_contactnum_core()
{
	fun_set_stop_button_contactnum_core();
	if (singleFieldFlag == true) {
		fun_hide(div_contactnum);
	}
	fun_stt_address();
}

function fun_set_next_button_contactnum()
{
	nextButton_contactnum.addEventListener('click', () => {
		fun_set_next_button_contactnum_core();
	});
}

function fun_set_prev_button_contactnum()
{
	prevButton_contactnum.addEventListener('click', () => {
		fun_set_stop_button_contactnum_core();
		if (singleFieldFlag == true) {
			fun_hide(div_contactnum);
		}
		fun_stt_ssn();
	});
}

function fun_set_play_button_contactnum()
{
	playButton_contactnum.addEventListener('click', () => {
		if (userMediaFlag == true) {
			audioRecorder_contactnum.stop();
			const blobObj = new Blob(audioChunks_contactnum, { type: 'audio/webm' });
			const audioUrl = URL.createObjectURL(blobObj);
			const audio = new Audio(audioUrl);
			audio.play();
			output_contactnum.innerHTML = '';
		}

		fun_enable_button(startButton_contactnum);
		recognition_contactnum.stop();
		window.speechSynthesis.cancel();
		fun_hide(output_contactnum);

		contactnum = document.getElementById("contactnum").value;
		fun_speak(contactnum, speech_contactnum);
	});
}
