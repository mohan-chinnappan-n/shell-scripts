// utils.js
// mchinnappan
//
// ----------------
// url Parameters handling
const urlParams = new URLSearchParams(window.location.search);
const org = urlParams.get('o');
const timer = urlParams.get('t'); 

// implement copy to clipboard
 const preEles =  document.getElementsByClassName('precpy');

 for (const ele of preEles) {
    const content = ele.innerText.trim();
     if (org) {
      if (content.match(/\$\{ORG\}/)) {
        const href = content.replace(/\$\{ORG\}/, org);
        const link = document.createElement('a');
        link.setAttribute('class', 'open');
        link.setAttribute('href', href.replace(/open/,'').replace(/"/g,""));
        link.setAttribute('target', "new");
        // link.innerText = href.replace(/open/,'').replace(/"/g,""); 
        link.innerText = 'Open Org';
        ele.parentElement.appendChild(link);

     }
    }
     const cpyBtn = document.createElement('button');
     cpyBtn.innerText = 'Copy';
     cpyBtn.setAttribute('class', 'cpy-btn')
     cpyBtn.addEventListener('click', evt => {

       /* Create a temporary input element to copy the text from */
       const tempInput = document.createElement("textarea");
       tempInput.value = content;
       document.body.appendChild(tempInput);
       /* Select and copy the text from the temporary input */
       tempInput.select();
        document.execCommand("copy");
        /* Remove the temporary input element */
        document.body.removeChild(tempInput);
        cpyBtn.style.background = '#99ccff';
      })
     
     ele.parentElement.appendChild(cpyBtn);
 };

 // implement speech
 const preSpeakEles =  document.getElementsByClassName('pre-speak');

 for (const ele of preSpeakEles) {
  const spkBtn = document.createElement('button');
  const spkStopBtn = document.createElement('button');


  spkBtn.innerText ='Speak';
  spkBtn.setAttribute('class', 'spk-btn')
  spkBtn.addEventListener('click', evt => {
    const speech = new SpeechSynthesisUtterance();
    speech.text =  ele.innerText.replace(/(\r\n|\r|\n)/g, "\n\n\n");
    speech.rate = 0.7; 
    // Add a pause at new lines and between lines
    speech.addEventListener('boundary', function(event) {
      if (event.name === 'word') {
        const word = event.target.text.substr(event.charIndex, event.charLength);
        if (word === '\n') {
          speech.pause();
          setTimeout(function() {
            speech.resume();
          }, 1000); // Adjust the pause duration between lines (in milliseconds)
        }
      }
    });
    window.speechSynthesis.cancel(); //for chrome bug
    window.speechSynthesis.speak(speech);
    spkBtn.style.background = '#99ccff';
    spkStopBtn.innerText ='stop/resume';
    spkStopBtn.style.display = 'block;'

    spkStopBtn.setAttribute('class', 'spk-stop-btn')

    spkStopBtn.addEventListener('click', e => {
      if (window.speechSynthesis.paused) window.speechSynthesis.resume()
      else window.speechSynthesis.pause();
    });

  });
  ele.parentElement.appendChild(spkBtn);
  ele.parentElement.appendChild(spkStopBtn);

};


// finish btn support
   const gcl_steps =  document.getElementsByTagName('google-codelab-step');
   for (const gcls of gcl_steps) {
    const finishBtn = document.createElement('button');
    finishBtn.innerText ="" + gcls.getAttribute('step');
    finishBtn.style.float = 'right';
    finishBtn.setAttribute('class', 'spk-btn')

     finishBtn.classList.add("jump-button");

    finishBtn.addEventListener('click', event => {
      if (gcls.style.backgroundColor === 'steelblue') {
        gcls.style.opacity = 1;
        gcls.style.backgroundColor="white";
      }
      else { 
         gcls.style.backgroundColor="steelblue";
         gcls.style.opacity = .8;
      }
    });
    gcls.appendChild(finishBtn);
   }


   // title link

   const addLinks = (text, link) => {
    const linkEle = document.createElement('a');
    linkEle.innerText = text;
    linkEle.setAttribute('href',link)
    const titleEle = document.getElementsByClassName('title')[0];
    linkEle.style.float = 'right';
    linkEle.setAttribute('class', 'headingLink');
    linkEle.setAttribute('target', 'new');
    titleEle.appendChild(linkEle);
}

// time stuff

const showTiming = () => {
  const startTime = new Date().getTime();
  const titleEle = document.getElementsByClassName('title')[0];
  const timerEle = document.createElement('div');
  timerEle.setAttribute('id', 'timer');
  timerEle.style.float = 'right';
  titleEle.appendChild(timerEle);

  const timerElement = document.getElementById('timer');
  
  // Update the timer element with the elapsed time every 10 second
  setInterval(updateTimer, 10000);
  
  function updateTimer() {
    const endTime = new Date().getTime();
    const timeSpent = endTime - startTime;
    const formattedTime = formatTime(timeSpent);
    timerElement.textContent = formattedTime;
  }

  function formatTime(duration) {
    const seconds = Math.floor((duration / 1000) % 60);
    const minutes = Math.floor((duration / (1000 * 60)) % 60);
    const hours = Math.floor((duration / (1000 * 60 * 60)) % 24);

    return (
      leadingZero(hours) + ':' + leadingZero(minutes) + ':' + leadingZero(seconds)
    );
  }

  function leadingZero(value) {
    return value < 10 ? '0' + value : value;
  }
}
showTiming();




 