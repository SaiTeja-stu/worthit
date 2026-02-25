import { initializeApp } from "https://www.gstatic.com/firebasejs/11.0.2/firebase-app.js";
import {
    getAuth,
    RecaptchaVerifier,
    signInWithPhoneNumber
} from "https://www.gstatic.com/firebasejs/11.0.2/firebase-auth.js";

const firebaseConfig = {
    apiKey: "AIzaSyCnN-6_10FdYI_r588jhOSRxB1jZq0CF1Y",
    authDomain: "worthit-58ab4.firebaseapp.com",
    projectId: "worthit-58ab4",
    storageBucket: "worthit-58ab4.firebasestorage.app",
    messagingSenderId: "250098409902",
    appId: "1:250098409902:web:797884e450e464c81da83f",
    measurementId: "G-GZB1RWJTYV"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
auth.useDeviceLanguage();

// ✅ Initialize reCAPTCHA (CORRECT WAY)
window.initRecaptcha = () => {
    if (!window.recaptchaVerifier) {
        window.recaptchaVerifier = new RecaptchaVerifier(
            auth,
            'recaptcha-container',
            {
                size: 'normal',
                callback: () => {
                    console.log("reCAPTCHA solved");
                },
                'expired-callback': () => {
                    console.log("reCAPTCHA expired");
                }
            }
        );
    }
};

// ✅ Send OTP
window.sendOtp = function () {
    const rawPhone = document.getElementById('phone').value;
    // Remove spaces, dashes, parentheses
    const phoneNumber = rawPhone.replace(/[\s\-\(\)]/g, '');

    if (!phoneNumber.startsWith('+')) {
        alert("Phone number must be in +91XXXXXXXXXX format");
        return;
    }

    if (phoneNumber.length < 10) {
        alert("Please enter a valid phone number");
        return;
    }

    window.initRecaptcha();

    signInWithPhoneNumber(auth, phoneNumber, window.recaptchaVerifier)
        .then((confirmationResult) => {
            window.confirmationResult = confirmationResult;
            alert("OTP Sent");
        })
        .catch((error) => {
            console.error("Error sending OTP:", error);
            // Alert the specific error code for debugging
            alert(`Error: ${error.message}\nCode: ${error.code}`);

            if (window.recaptchaVerifier) {
                window.recaptchaVerifier.clear();
                // Do not nullify immediately to allow retry without page reload issues if possible, 
                // but for now keeping logic provided to reset.
                window.recaptchaVerifier = null;
            }
        });
};

// ✅ Verify OTP
window.verifyOtp = function () {
    const code = document.getElementById('otp').value;

    if (!window.confirmationResult) {
        alert("Please send OTP first");
        return;
    }

    window.confirmationResult.confirm(code)
        .then((result) => {
            alert("Login successful 🎉\nUID: " + result.user.uid);
        })
        .catch((error) => {
            alert("Wrong OTP");
        });
};
