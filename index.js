/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const environment = admin.firestore().collection('User').doc('O9OyAbjizgupwiP87XXf').collection('farm').doc('aUXxaWWPtxhGEGs5mqn0').collection('environment');//เข้าถึงcollection environment
const daily_average =  admin.firestore().collection('User').doc('O9OyAbjizgupwiP87XXf').collection('farm').doc('aUXxaWWPtxhGEGs5mqn0').collection('daily_average');//เข้าถึงcollection daily_average
const monthly_average = admin.firestore().collection('User').doc('O9OyAbjizgupwiP87XXf').collection('farm').doc('aUXxaWWPtxhGEGs5mqn0').collection('monthly_average');//เข้าถึงcollection monthly_average
exports.calculateAndSaveDailyAverage = functions.firestore
    .document('environment/{dateTime}')
    .onWrite(async (change, context) => {
        const date = context.params.dateTime;
        const day = date.split(' ')[0]; // เพื่อให้ doc id เป็นวันเดียวกันในทุกวัน

        const data = await admin.firestore().collection('User').doc('O9OyAbjizgupwiP87XXf').collection('farm').doc('aUXxaWWPtxhGEGs5mqn0').collection('environment')
            .where('dateTime', '>=', day)
            .where('dateTime', '<', `${day} 23:59`) // จำกัดข้อมูลให้เฉพาะวันนั้นๆ
            .get();

        let total = 0;
        let count = 0;

        data.forEach(doc => {
            total += doc.data().value;
            count++;
        });

        const average = total / count;

        await admin.firestore().collection('daily_averages').doc(day).set({
            date: day,
            average: average
        });
    });

exports.calculateAndSaveMonthlyAverage = functions.firestore
    .document('daily_averages/{date}')
    .onWrite(async (change, context) => {
        const date = context.params.date;
        const monthYear = date.split('/')[0]; // เพื่อให้ doc id เป็นเดือนและปีเดียวกันในทุกเดือน

        const data =   admin.firestore().collection('User').doc('O9OyAbjizgupwiP87XXf').collection('farm').doc('aUXxaWWPtxhGEGs5mqn0').collection('daily_average')
            .where('date', '>=', `${monthYear}/01`)
            .where('date', '<', `${monthYear}/31`) // จำกัดข้อมูลให้เฉพาะเดือนนั้นๆ
            .get();

        let total = 0;
        let count = 0;

        data.forEach(doc => {
            total += doc.data().average;
            count++;
        });

        const average = total / count;

        await admin.firestore().collection('User').doc('O9OyAbjizgupwiP87XXf').collection('farm').doc('aUXxaWWPtxhGEGs5mqn0').collection('monthly_average').set({
            monthYear: monthYear,
            average: average
        });
    });