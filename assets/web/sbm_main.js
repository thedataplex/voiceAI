const recognition = new webkitSpeechRecognition() || new SpeechRecognition();
const singleFieldFlag = true;
const userMediaFlag = false;

const startButton = document.getElementById('startb_name');
const stopButton = document.getElementById('stopb_name');
const nextButton = document.getElementById('nextb_name');
const prevButton = document.getElementById('prevb_name');
const playButton = document.getElementById('playb_name');
const helpButton = document.getElementById('helpb_name');


let output_name = document.getElementById('output_name');
let audioRecorder_name;
let audioChunks_name = [];
//let speak_name_header = "Please Enter Patient Name after pressing MIC Button";
let speak_name_header = "Please Enter Patient Name. ";
let speak_name_footer = "Patient Name is ";
let speak_name_help = speak_name_header + ". When you are done with entering Patient Name, Please don't forget to press stop button.";
speak_name_help = speak_name_help + " After that, You can either switch to next field by clicking next button or click play button to listen the recorded Patient Name";

var speech_name;

const startButton_dob = document.getElementById('startb_dob');
const stopButton_dob = document.getElementById('stopb_dob');
const nextButton_dob = document.getElementById('nextb_dob');
const prevButton_dob = document.getElementById('prevb_dob');
const playButton_dob = document.getElementById('playb_dob');
const helpButton_dob = document.getElementById('helpb_dob');
let output_dob = document.getElementById('output_dob');
let audioRecorder_dob;
let audioChunks_dob = [];
//let speak_dob_header = "Please enter Patient Date Of Birth in DD/MM/YYYY format after pressing MIC Button";
//let speak_dob_header = "Please enter Patient Date Of Birth after pressing MIC Button";
let speak_dob_header = "Please enter Patient Date Of Birth. ";
let speak_dob_footer = "Patient Date Of Birth is ";
let speak_dob_help = speak_dob_header + ". When you are done with entering Date of Birth , Please don't forget to press stop button";
speak_dob_help = speak_dob_help + " After that, You can either switch to next field by clicking next button or click play button to listen the recorded Patient Date of Birth";
var speech_dob;


const startButton_address = document.getElementById('startb_address');
const stopButton_address = document.getElementById('stopb_address');
const nextButton_address = document.getElementById('nextb_address');
const prevButton_address = document.getElementById('prevb_address');
const playButton_address = document.getElementById('playb_address');
const helpButton_address = document.getElementById('helpb_address');
let output_address = document.getElementById('output_address');
let audioRecorder_address;
let audioChunks_address = [];
//let speak_address_header = "Please enter Patient Address after pressing MIC Button";
let speak_address_header = "Please enter Patient Address. ";
let speak_address_footer = "Patient Address is ";
let speak_address_help = speak_address_header + ". When you are done with entering Address , Please don't forget to press stop button.";
speak_address_help = speak_address_help + " After that, You can either switch to next field by clicking next button or click play button to listen the recorded Patient Address";
let speech_address;

const startButton_contactnum = document.getElementById('startb_contactnum');
const stopButton_contactnum = document.getElementById('stopb_contactnum');
const nextButton_contactnum = document.getElementById('nextb_contactnum');
const prevButton_contactnum = document.getElementById('prevb_contactnum');
const playButton_contactnum = document.getElementById('playb_contactnum');
const helpButton_contactnum = document.getElementById('helpb_contactnum');
let output_contactnum = document.getElementById('output_contactnum');
let audioRecorder_contactnum;
let audioChunks_contactnum = [];
//let speak_contactnum_header = "Please enter Patient Mobile Number after pressing MIC Button.";
let speak_contactnum_header = "Please enter Patient Mobile Number. ";
let speak_contactnum_footer = "Patient Mobile Number is ";
let speak_contactnum_help = speak_contactnum_header + ". When you are done with entering Mobile Number , Please don't forget to press stop button";
speak_contactnum_help = speak_contactnum_help + " After that, You can either switch to next field by clicking next button or click play button to listen the recorded Patient Mobile Number";
let speech_contactnum;


const startButton_ssn = document.getElementById('startb_ssn');
const stopButton_ssn = document.getElementById('stopb_ssn');
const nextButton_ssn = document.getElementById('nextb_ssn');
const prevButton_ssn = document.getElementById('prevb_ssn');
const playButton_ssn = document.getElementById('playb_ssn');
const helpButton_ssn = document.getElementById('helpb_ssn');
let output_ssn = document.getElementById('output_ssn');
let audioRecorder_ssn;
let audioChunks_ssn = [];
//let speak_ssn_header = "Please enter Patient Social Security Number after pressing MIC Button.";
let speak_ssn_header = "Please enter Patient Social Security Number. ";
let speak_ssn_footer = "Patient Social Security Number is ";
let speak_ssn_help = speak_ssn_header + ". When you are done with entering SSN , Please don't forget to press stop button";
speak_ssn_help = speak_ssn_help + " After that, You can either switch to next field by clicking next button or click play button to listen the recorded Patient SSN";
let speech_ssn;

var statusbox = document.getElementById("status_box");
window.fun_stop_recording_all = function fun_stop_recording_all()
{
	if(typeof audioRecorder_name !== "undefined")
	{
		audioRecorder_name.stop();
		//output_name.innerHTML = 'Recording stopped for Patient Name! Click on the play button to play the recorded audio.';
	}
	if(typeof audioRecorder_dob !== "undefined")
	{
		audioRecorder_dob.stop();
		//output_dob.innerHTML = "Recording stopped for Patient's Date of Birth! Click on the play button to play the recorded a    udio.";
	}
	if(typeof audioRecorder_address !== "undefined")
	{
		audioRecorder_address.stop();
		//output_address.innerHTML = 'Recording stopped for Patient Address! Click on the play button to play the recorded audio.';
	}
	if(typeof audioRecorder_contactnum !== "undefined")
	{
		audioRecorder_contactnum.stop();
		//output_contactnum.innerHTML = "Recording stopped for Patient's Phone Number! Click on the play button to play the recorde    d audio.";
	}
	if(typeof audioRecorder_ssn !== "undefined")
	{
		audioRecorder_ssn.stop();
		//output_contactnum.innerHTML = "Recording stopped for Patient's Phone Number! Click on the play button to play the recorde    d audio.";
	}
}

window.fun_speak_msg = function fun_speak_msg(msg)
{
	if ('speechSynthesis' in window) {
	//alert("TextToSpeech is supported");
	} else {
		alert("TextToSpeech is NOT supported");
	}
	let speech = new SpeechSynthesisUtterance();
	speech.lang = "en-US";
	speech.text = msg;
	speech.volume = 1;
	speech.rate = 1;
	speech.pitch = 1;
	window.speechSynthesis.speak(speech);
}

window.fun_speak = function fun_speak(msg, speech)
{
	if ('speechSynthesis' in window) {
	//alert("TextToSpeech is supported");
	} else {
		alert("TextToSpeech is NOT supported");
	}
	speech.text = msg;
	window.speechSynthesis.speak(speech);
}

function fun_set_help_button()
{
	helpButton.addEventListener('click', () => {
        fun_speak(speak_name_help, speech_name);
	});

	helpButton_dob.addEventListener('click', () => {
        fun_speak(speak_dob_help, speech_dob);
	});
	helpButton_address.addEventListener('click', () => {
        fun_speak(speak_address_help, speech_address);
	});
	helpButton_contactnum.addEventListener('click', () => {
        fun_speak(speak_contactnum_help, speech_contactnum);
	});
	helpButton_ssn.addEventListener('click', () => {
        fun_speak(speak_ssn_help, speech_ssn);
	});
}

window.fun_init_ssn = function fun_init_ssn()
{
	speech_ssn = new SpeechSynthesisUtterance();
	speech_ssn.lang = "en-US";
	speech_ssn.volume = 1;
	speech_ssn.rate = 1;
	speech_ssn.pitch = 1;
}

window.fun_init_contactnum = function fun_init_contactnum()
{
	speech_contactnum = new SpeechSynthesisUtterance();
	speech_contactnum.lang = "en-US";
	speech_contactnum.volume = 1;
	speech_contactnum.rate = 1;
	speech_contactnum.pitch = 1;
}

window.fun_init_address = function fun_init_address()
{
	speech_address = new SpeechSynthesisUtterance();
	speech_address.lang = "en-US";
	speech_address.volume = 1;
	speech_address.rate = 1;
	speech_address.pitch = 1;
}

window.fun_init_dob = function fun_init_dob()
{
	speech_dob = new SpeechSynthesisUtterance();
	speech_dob.lang = "en-US";
	speech_dob.volume = 1;
	speech_dob.rate = 1;
	speech_dob.pitch = 1;
}

window.fun_init_name = function fun_init_name()
{
	speech_name = new SpeechSynthesisUtterance();
	speech_name.lang = "en-US";
	speech_name.volume = 1;
	speech_name.rate = 1;
	speech_name.pitch = 1;
}

window.fun_begin = function fun_begin()
{
	fun_init_name();
	fun_init_dob();
	fun_init_address();
	fun_init_contactnum();
	fun_init_ssn();
	fun_set_help_button();
	fun_stt_name();
	//fun_dob();
	//fun_address();
	//fun_contactnum();
}

window.fun_end = function fun_end()
{
	//fun_show(div_end);
	var name = document.getElementById("name").value;
	var dob = document.getElementById("dob").value;
	var ssn = document.getElementById("ssn").value;
	var contactnum = document.getElementById("contactnum").value;
	var address = document.getElementById("address").value;
	let msg = "";

	if (name.length == 0) {
		msg = msg + speak_name_footer + " Empty. ";
	} else {
		msg = msg + speak_name_footer + " " + name + ". ";
	}

	if (dob.length == 0) {
		msg = msg + speak_dob_footer + " Empty. ";
	} else {
		msg = msg + speak_dob_footer + " " + dob + ". ";
	}

	if (ssn.length == 0) {
		msg = msg + speak_ssn_footer + " Empty. ";
	} else {
		msg = msg + speak_ssn_footer + " " + ssn + ". ";
	}

	if (contactnum.length == 0) {
		msg = msg + speak_contactnum_footer + " Empty. ";
	} else {
		msg = msg + speak_contactnum_footer + " " + contactnum + ". ";
	}

	if (address.length == 0) {
		msg = msg + speak_address_footer + " Empty. ";
	} else {
		msg = msg + speak_address_footer + " " + address + ". ";
	}

	fun_speak_msg(msg);
}

window.fun_reset = function fun_reset()
{
	//fun_show(div_end);
	
	var name = document.getElementById("name");
	var dob = document.getElementById("dob");
	var ssn = document.getElementById("ssn");
	var contactnum = document.getElementById("contactnum");
	var address = document.getElementById("address");
	name.value = "";
	dob.value = "";
	ssn.value = "";
	contactnum.value = "";
	address.value = "";
}
window.fun_submit = function fun_submit()
{
	alert("Feature In Progress");
}

window.fun_show = function fun_show(obj)
{
	obj.style.display = 'block';
}

window.fun_hide = function fun_hide(obj)
{
	obj.style.display = 'none';
}

window.fun_disable_button = function fun_disable_button(btn)
{
	btn.disabled = true;
}

window.fun_enable_button = function fun_enable_button(btn)
{
	btn.disabled = false;
}
