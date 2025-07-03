<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>403 Forbidden</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css?family=Limelight&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet">
    <style>
        :root {
            --red: #CF352C;
            --dark-red: #9C0502;
            --light-beige: #F3F2EE;
            --beige: #EEE8E0;
            --dark-beige: #DAD2C9;
            --black: #1D2528;
            --gray: #38434A;
            --lighter-gray: #49555B;
            --white: #FFF;
            --bouncer-skin: #FFB482;
            --pole: #F5AE4E;
            --pole-shadow: #DF9D41;
        }
        html, body {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Limelight', cursive;
            color: var(--gray);
            background: var(--beige);
        }
        .hover {
            width: 100vw;
            height: 100vh;
            position: relative;
            overflow: hidden;
        }
        .background {
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
        }
        .background::before {
            display: block;
            content: '';
            position: absolute;
            top: -100px;
            left: 50%;
            transform: translateX(-50%);
            width: 450px;
            height: 450px;
            background: var(--beige);
            border-radius: 50%;
            z-index: -1;
        }
        .background::after {
            display: block;
            content: '';
            position: absolute;
            top: -150px;
            left: 50%;
            transform: translateX(-50%);
            width: 550px;
            height: 550px;
            background: var(--light-beige);
            border-radius: 50%;
            z-index: -2;
        }
        .door {
            position: relative;
            width: 180px;
            height: 300px;
            margin: 0 auto -10px;
            background: var(--light-beige);
            border: 10px solid var(--dark-beige);
            border-radius: 3px;
            font-size: 50px;
            line-height: 3;
            text-align: center;
            text-shadow: 0 2px var(--pole);
            z-index: 2;
        }
        .door::before {
            display: block;
            content: '';
            position: absolute;
            top: 140px;
            right: 10px;
            width: 25px;
            height: 25px;
            background: var(--black);
            border-radius: 50%;
        }
        .door::after {
            display: block;
            content: '';
            position: absolute;
            top: 148px;
            right: 18px;
            width: 35px;
            height: 10px;
            background: var(--lighter-gray);
            border-radius: 5px;
        }
        .rug {
            width: 180px;
            border-bottom: 120px solid var(--red);
            border-left: 50px solid transparent;
            border-right: 50px solid transparent;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }
        .rug::before {
            display: block;
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 10px;
            background: var(--dark-red);
        }
        .foreground {
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
        }
        /* Bouncer styles (simplified for demo) */
        .bouncer {
            position: relative;
            left: -130px;
            transition: left 1.5s;
        }
        .bouncer .head {
            position: relative;
            left: 10px;
            margin-bottom: 10px;
            width: 65px;
            height: 90px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: visible;
        }
        .bouncer .body {
            position: relative;
            width: 110px;
            height: 270px;
            background: var(--black);
            border-top-right-radius: 45px;
            border-top-left-radius: 15px;
        }
        .bouncer .arm {
            position: absolute;
            top: 105px;
            left: -20px;
            width: 60px;
            height: 230px;
            background: var(--lighter-gray);
            border-radius: 30px;
            box-shadow: -1px 0px var(--black);
            transform: rotate(-30deg);
            transform-origin: top center;
            z-index: 20;
            transition: transform 1s;
        }
        .poles {
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-25%);
        }
        .pole {
            position: absolute;
            bottom: 0;
            width: 15px;
            height: 135px;
            background: var(--pole);
        }
        .pole.left { left: 200px; }
        .pole.right { right: 200px; }
        .pole::before {
            display: block;
            content: '';
            position: absolute;
            top: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 25px;
            height: 25px;
            background: var(--pole);
            border-radius: 50%;
            box-shadow: inset 0 -2px var(--pole-shadow);
        }
        .pole::after {
            display: block;
            content: '';
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            width: 25px;
            height: 4px;
            background: var(--pole);
            border-radius: 4px;
            box-shadow: 0 2px var(--pole-shadow);
        }
        .rope {
            position: absolute;
            top: -110px;
            left: -218px;
            width: 150px;
            height: 75px;
            border: 20px solid var(--red);
            border-top: 0;
            border-bottom-left-radius: 150px;
            border-bottom-right-radius: 150px;
            box-shadow: 0 2px var(--dark-red);
            box-sizing: border-box;
            transition: width 1.5s;
        }
        .hover:hover .bouncer {
            left: 130px;
        }
        .hover:hover .arm {
            transform: rotate(-42deg);
        }
        .hover:hover .rope {
            width: 435px;
        }
        .error-message {
            position: absolute;
            top: 30px;
            left: 0;
            width: 100vw;
            text-align: center;
            z-index: 10;
        }
        .error-message h1 {
            font-size: 3em;
            margin: 0 0 0.5em 0;
            color: var(--red);
            text-shadow: 0 2px var(--dark-red);
        }
        .error-message h2 {
            font-size: 2em;
            margin: 0 0 1em 0;
        }
        .error-message .desc {
            font-size: 1.2em;
            margin-bottom: 1.5em;
            color: var(--gray);
            font-family: 'Roboto', Arial, Helvetica, sans-serif;
        }
        .back-btn {
            margin: 0 auto;
            display: block;
            font-family: 'Roboto', Arial, Helvetica, sans-serif;
            font-size: 1.2em;
            padding: 0.7em 2em;
            background: var(--red);
            color: #fff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 2px 8px #0006;
            transition: background 0.2s;
        }
        .back-btn:hover {
            background: var(--dark-red);
        }
    </style>
</head>
<body>
<div class="hover">
    <div class="error-message">
        <h1>403: Forbidden</h1>
        <h2>Intruder!</h2>
        <div class="desc">Bạn không có quyền truy cập tính năng này.</div>
        <button class="back-btn" onclick="window.history.back()">Quay lại trang trước</button>
    </div>
    <div class="background">
        <div class="door">403</div>
        <div class="rug"></div>
    </div>
    <div class="foreground">
        <div class="bouncer">
            <div class="head">
                <img src="<%=request.getContextPath()%>/images/hn.png" alt="face" style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; position: relative; top: 0; left: 0;" />
            </div>
            <div class="body"></div>
            <div class="arm"></div>
        </div>
        <div class="poles">
            <div class="pole left"></div>
            <div class="pole right"></div>
            <div class="rope"></div>
        </div>
    </div>
</div>
</body>
</html> 