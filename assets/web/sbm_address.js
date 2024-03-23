let recognition_address = new webkitSpeechRecognition() || new SpeechRecognition();
//let recognition_address = recognition;
recognition_address.continuous = true;

window.fun_stt_address = function fun_stt_address()
{
	fun_show(div_address);
	fun_speak(speak_address_header, speech_address);
	statusbox.value = speak_address_header + "\n";
	fun_set_start_button_address_core();
	
	if (userMediaFlag == true) {
		navigator.mediaDevices.getUserMedia({ audio: true })
		.then(stream => {
         
			audioRecorder_address = new MediaRecorder(stream);
            
			audioRecorder_address.addEventListener('dataavailable', e => {
				audioChunks_address.push(e.data);
			});
            
			fun_set_start_button_address();
			fun_set_stop_button_address();
			fun_set_next_button_address();
			fun_set_prev_button_address();
			fun_set_play_button_address();
		}).catch(err => {
			alert('Error: ' + err);
		});
	} else {
		fun_set_start_button_address();
		fun_set_stop_button_address();
		fun_set_next_button_address();
		fun_set_prev_button_address();
		fun_set_play_button_address();
	}

	recognition_address.addEventListener("result", (event) => {
    	const result = event.results[event.results.length - 1][0].transcript;
		let address = document.getElementById("address");
		let cmd = result.trim();
		if (cmd === "next") {
			fun_set_next_button_address_core();
		} else {
			address.value = address.value + result;
			statusbox.value = statusbox.value + result;
		}
		//fun_show(statusbox);
	});

	recognition_address.addEventListener("audioend", () => {
    	startButton_address.disabled = false;
		fun_hide(output_address);
	});
}

function fun_set_start_button_address_core()
{
	//window.speechSynthesis.cancel();
	fun_disable_button(startButton_address);
	//audioChunks_address = [];
	fun_show(output_address);
	output_address.innerHTML = 'Recording started for Patient Address! Speak now. When you are done, Say "Next" or Press Next Button';

	if (userMediaFlag == true) {
		audioRecorder_address.start();
	}

	recognition_address.start();
}

function fun_set_start_button_address()
{
	startButton_address.addEventListener('click', () => {
		window.speechSynthesis.cancel();
		fun_set_start_button_address_core();
	});
}

function fun_set_stop_button_address_core()
{
	if (userMediaFlag == true) {
		audioRecorder_address.stop();
	}

	fun_enable_button(startButton_address);
	recognition_address.stop();
	window.speechSynthesis.cancel();
	fun_hide(output_address);
}

function fun_set_stop_button_address()
{
	stopButton_address.addEventListener('click', () => {
		fun_set_stop_button_address_core();
	});
}

function fun_set_next_button_address_core()
{
	fun_set_stop_button_address_core();
	if (singleFieldFlag == true) {
		fun_show(div_name);
		fun_show(div_dob);
		fun_show(div_ssn);
		fun_show(div_contactnum);
		fun_show(div_address);
	}
	fun_show(div_end);
}

function fun_set_next_button_address()
{
	nextButton_address.addEventListener('click', () => {
		fun_set_next_button_address_core();
	});
}

function fun_set_prev_button_address()
{
	prevButton_address.addEventListener('click', () => {
		fun_set_stop_button_address_core();
		if (singleFieldFlag == true) {
			fun_hide(div_name);
			fun_hide(div_dob);
			fun_hide(div_ssn);
			fun_hide(div_contactnum);
			fun_hide(div_address);
		}
		fun_hide(div_end);
		fun_stt_contactnum();
	});
}

function fun_set_play_button_address()
{
	playButton_address.addEventListener('click', () => {
		if (userMediaFlag == true) {
			audioRecorder_address.stop();
			const blobObj = new Blob(audioChunks_address, { type: 'audio/webm' });
			const audioUrl = URL.createObjectURL(blobObj);
			const audio = new Audio(audioUrl);
			audio.play();
			output_address.innerHTML = '';
		}

		fun_enable_button(startButton_address);
		recognition_address.stop();
		window.speechSynthesis.cancel();
		fun_hide(output_address);

		address = document.getElementById("address").value;
		fun_speak(address, speech_address);
	});
}
