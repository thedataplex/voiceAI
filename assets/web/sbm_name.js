let recognition_name = new webkitSpeechRecognition() || new SpeechRecognition();
//let recognition_name = recognition;
recognition_name.continuous = true;

window.fun_stt_name = function fun_stt_name()
{
	fun_show(div_name);
	fun_speak(speak_name_header, speech_name);
	statusbox.value = speak_name_header + "\n";
	fun_set_start_button_core();

	if (userMediaFlag == true) {
		navigator.mediaDevices.getUserMedia({ audio: true })
		.then(stream => {
         
			audioRecorder_name = new MediaRecorder(stream);
            
			audioRecorder_name.addEventListener('dataavailable', e => {
				audioChunks_name.push(e.data);
			});
            
			fun_set_start_button();
			fun_set_stop_button();
			fun_set_next_button();
			fun_set_prev_button();
			fun_set_play_button();
		}).catch(err => {
			alert('Error: ' + err);
		});
	} else {
		fun_set_start_button();
		fun_set_stop_button();
		fun_set_next_button();
		fun_set_prev_button();
		fun_set_play_button();
	}

	recognition_name.addEventListener("result", (event) => {
   	const result = event.results[event.results.length - 1][0].transcript;
		let name = document.getElementById("name");
		let cmd = result.trim();
		if (cmd === "next") {
			fun_set_next_button_core();
		} else if (cmd === "prev") {
			fun_set_prev_button_core();
		} else if (cmd === "stop") {
			fun_set_stop_button_core();
		} else if (cmd === "play") {
			fun_set_play_button_core();
		} else {
			name.value = name.value + result;
			statusbox.value = statusbox.value + result;
		}
	//fun_show(statusbox);
	});

	recognition_name.addEventListener("audioend", () => {
		fun_enable_button(startButton);
		fun_hide(output_name);
	});
}

function fun_set_start_button_core()
{
	//window.speechSynthesis.cancel();
	fun_disable_button(startButton);
	//audioChunks_name = [];
	fun_show(output_name);
	output_name.innerHTML = 'Recording started for Patient Name! Speak now. When you are done, Say "Next" or press Next Button';
	recognition_name.start();

	if (userMediaFlag == true) {
		audioRecorder_name.start();
	}
}

function fun_set_start_button()
{
	startButton.addEventListener('click', () => {
		window.speechSynthesis.cancel();
		fun_set_start_button_core();
	});
}

function fun_set_stop_button_core()
{
	if (userMediaFlag == true) {
		audioRecorder_name.stop();
	}

	fun_enable_button(startButton);
	recognition_name.stop();
	window.speechSynthesis.cancel();
	fun_hide(output_name);
}

function fun_set_stop_button()
{
	stopButton.addEventListener('click', () => {
		fun_set_stop_button_core();
	});
}

function fun_set_next_button_core()
{
	fun_set_stop_button_core();
	if (singleFieldFlag == true) {
		fun_hide(div_name);
	}
	fun_stt_dob();
}

function fun_set_next_button()
{
	nextButton.addEventListener('click', () => {
		fun_set_next_button_core();
	});
}

function fun_set_prev_button_core()
{
	fun_set_stop_button_core();
	if (singleFieldFlag == true) {
		fun_hide(div_name);
	}
	//fun_begin();
}

function fun_set_prev_button()
{
	prevButton.addEventListener('click', () => {
		fun_set_prev_button_core();
	});
}

function fun_set_play_button_core()
{
	if (userMediaFlag == true) {
		audioRecorder_name.stop();
		const blobObj = new Blob(audioChunks_name, { type: 'audio/webm' });
		const audioUrl = URL.createObjectURL(blobObj);
		const audio = new Audio(audioUrl);
		audio.play();
		output_name.innerHTML = '';
	}

	fun_enable_button(startButton);
	recognition_name.stop();
	window.speechSynthesis.cancel();
	fun_hide(output_name);

	let name = document.getElementById("name").value;
	fun_speak(name, speech_name);
}

function fun_set_play_button()
{
	playButton.addEventListener('click', () => {
		fun_set_play_button_core();
	});
}
