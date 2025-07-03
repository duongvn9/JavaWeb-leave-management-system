<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>500 Internal Server Error</title>
    <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/typed.js@2.0.12"></script>
    <style>
        #particles-js {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: 1;
        }

        body {
            background: #97cfca;
            overflow: hidden;
            margin: 0;
            padding: 0;
            font-family: 'Courier New', monospace;
        }

        .terminal-window {
            text-align: left;
            width: 37.5rem;
            height: 22.5rem;
            border-radius: .625rem;
            margin: auto;
            position: relative;
            top: 10.5rem;
            z-index: 2;
        }

        .terminal-window header {
            background: #E0E8F0;
            height: 1.875rem;
            border-radius: .5rem .5rem 0 0;
            padding-left: .625rem;
        }

        .terminal-window header .button {
            width: .75rem;
            height: .75rem;
            margin: .625rem .25rem 0 0;
            display: inline-block;
            border-radius: .5rem;
        }

        .terminal-window header .button.green {
            background: #3BB662;
        }

        .terminal-window header .button.yellow {
            background: #E5C30F;
        }

        .terminal-window header .button.red {
            background: #E75448;
        }

        .terminal-window section.terminal {
            color: white;
            font-family: Menlo, Monaco, "Consolas", "Courier New", "Courier";
            font-size: 11pt;
            background: #30353A;
            padding: .625rem;
            box-sizing: border-box;
            position: absolute;
            width: 100%;
            top: 1.875rem;
            bottom: 0;
            overflow: auto;
        }

        .terminal-window section.terminal .typed-cursor {
            opacity: 1;
            -webkit-animation: blink 0.7s infinite;
            -moz-animation: blink 0.7s infinite;
            animation: blink 0.7s infinite;
        }

        @keyframes blink {
            0% { opacity: 1; }
            50% { opacity: 0; }
            100% { opacity: 1; }
        }

        @-webkit-keyframes blink {
            0% { opacity: 1; }
            50% { opacity: 0; }
            100% { opacity: 1; }
        }

        @-moz-keyframes blink {
            0% { opacity: 1; }
            50% { opacity: 0; }
            100% { opacity: 1; }
        }

        .terminal-data { 
            display: none; 
        }
        
        .terminal-window .gray { 
            color: gray; 
        }
        
        .terminal-window .green { 
            color: green;
        }
        
        .terminal-window .red { 
            color: #ff6b6b;
        }
        
        .terminal-window .yellow { 
            color: #ffd93d;
        }

        .back-button {
            position: fixed;
            bottom: 2rem;
            left: 50%;
            transform: translateX(-50%);
            z-index: 3;
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            padding: 12px 24px;
            border-radius: 24px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .back-button:hover {
            background: rgba(255, 255, 255, 1);
            transform: translateX(-50%) translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
        }

        /* Media for mobile responsive viewing */
        @media only screen and (max-width: 600px) {
            .terminal-window {
                text-align: left;
                width: 37.5vmin;
                height: 22.5vmin;
                border-radius: .625vmin;
                margin: auto;
                position: relative;
                top: 30.5vmin;
            }
            
            .terminal-window header {
                background: #E0E8F0;
                height: 1.875vmin;
                border-radius: .5vmin .5vmin 0 0;
                padding-left: 1vmin;
            }
            
            .terminal-window header .button {
                width: .75vmin;
                height: .75vmin;
                margin: .625vmin .25vmin 0 0;
                display: inline-block;
                border-radius: .5vmin;
            }
            
            .terminal-window section.terminal {
                color: white;
                font-family: Menlo, Monaco, "Consolas", "Courier New", "Courier";
                font-size: .6875vmin;
                background: #30353A;
                padding: .625vmin;
                box-sizing: border-box;
                position: absolute;
                width: 100%;
                top: 1.875vmin;
                bottom: 0;
                overflow: auto;
            }
            
            .back-button {
                bottom: 1rem;
                padding: 8px 16px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div id="particles-js"></div>
    <div style="text-align:center;z-index:3;position:relative;top:7rem;">
        <table style="margin: 0 auto; background: #fff3cd; border-radius: 8px; border: 1px solid #ffeeba; box-shadow:0 2px 8px rgba(0,0,0,0.08); margin-bottom:24px;">
            <tr>
                <td style="color:#856404; padding:16px 32px; font-size:1.2rem; font-weight:500; font-family: 'Fira Mono', monospace; text-align:center;">
                    Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau hoặc liên hệ quản trị viên để được hỗ trợ.
                </td>
            </tr>
        </table>
    </div>
    <div class="terminal-window">
        <header>
            <div class="button green"></div>
            <div class="button yellow"></div>
            <div class="button red"></div>
        </header>
        <section class="terminal">
            <div class="history"></div>
            $&nbsp;<span class="prompt"></span>
            <span class="typed-cursor"></span>
        </section>
    </div>

    <script>
        particlesJS("particles-js", {
            "particles": {
                "number": {
                    "value": 155,
                    "density": {
                        "enable": true,
                        "value_area": 789.1476416322727
                    }
                },
                "color": {
                    "value": "#ffffff"
                },
                "shape": {
                    "type": "circle",
                    "stroke": {
                        "width": 0,
                        "color": "#000000"
                    },
                    "polygon": {
                        "nb_sides": 5
                    },
                    "image": {
                        "src": "img/github.svg",
                        "width": 100,
                        "height": 100
                    }
                },
                "opacity": {
                    "value": 0.48927153781200905,
                    "random": false,
                    "anim": {
                        "enable": true,
                        "speed": 1,
                        "opacity_min": 0,
                        "sync": false
                    }
                },
                "size": {
                    "value": 2,
                    "random": true,
                    "anim": {
                        "enable": true,
                        "speed": 2,
                        "size_min": 0,
                        "sync": false
                    }
                },
                "line_linked": {
                    "enable": true,
                    "distance": 150,
                    "color": "#ffffff",
                    "opacity": 0.4,
                    "width": 1
                },
                "move": {
                    "enable": true,
                    "speed": 0.2,
                    "direction": "none",
                    "random": true,
                    "straight": false,
                    "out_mode": "out",
                    "bounce": false,
                    "attract": {
                        "enable": false,
                        "rotateX": 600,
                        "rotateY": 1200
                    }
                }
            },
            "interactivity": {
                "detect_on": "canvas",
                "events": {
                    "onhover": {
                        "enable": true,
                        "mode": "bubble"
                    },
                    "onclick": {
                        "enable": true,
                        "mode": "push"
                    },
                    "resize": true
                },
                "modes": {
                    "grab": {
                        "distance": 400,
                        "line_linked": {
                            "opacity": 1
                        }
                    },
                    "bubble": {
                        "distance": 83.91608391608392,
                        "size": 1,
                        "duration": 3,
                        "opacity": 1,
                        "speed": 3
                    },
                    "repulse": {
                        "distance": 200,
                        "duration": 0.4
                    },
                    "push": {
                        "particles_nb": 4
                    },
                    "remove": {
                        "particles_nb": 2
                    }
                }
            },
            "retina_detect": true
        });

        $(function() {
            var data = [
                {
                    action: 'type',
                    strings: ["Accessing server logs..."],
                    output: 'checking system status..<br><br>',
                    postDelay: 1000
                },
                {
                    action: 'type',
                    strings: ["500 Internal Server Error"],
                    output: '<span class="red">Server encountered an unexpected condition</span><br>&nbsp;',
                    postDelay: 1000
                },
                {
                    action: 'type',
                    strings: ["These are not the error codes you're looking for.", 'Please either report this error to an administrator or return back and forget you were here...'],
                    postDelay: 2000
                },
                {
                    action: 'type',
                    strings: ["System recovery in progress..."],
                    output: '<span class="yellow">Attempting to restore connection...</span><br>&nbsp;',
                    postDelay: 1500
                },
                {
                    action: 'type',
                    strings: ["Connection failed. Please try again later."],
                    output: '<span class="gray">Error logged at: ' + new Date().toLocaleString() + '</span><br>&nbsp;',
                    postDelay: 1000
                }
            ];
            runScripts(data, 0);
        });

        function runScripts(data, pos) {
            var prompt = $('.prompt'),
                script = data[pos];
            if(script.clear === true) {
                $('.history').html('');
            }
            switch(script.action) {
                case 'type':
                    // cleanup for next execution
                    prompt.removeData();
                    $('.typed-cursor').text('');
                    prompt.typed({
                        strings: script.strings,
                        typeSpeed: 30,
                        callback: function() {
                            var history = $('.history').html();
                            history = history ? [history] : [];
                            history.push('$ ' + prompt.text());
                            if(script.output) {
                                history.push(script.output);
                                prompt.html('');
                                $('.history').html(history.join('<br>'));
                            }
                            // scroll to bottom of screen
                            $('section.terminal').scrollTop($('section.terminal').height());
                            // Run next script
                            pos++;
                            if(pos < data.length) {
                                setTimeout(function() {
                                    runScripts(data, pos);
                                }, script.postDelay || 1000);
                            }
                        }
                    });
                    break;
                case 'view':
                    break;
            }
        }
    </script>
</body>
</html> 