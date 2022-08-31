const fs = require('fs');
const child = require("child_process");

let newVersion = process.argv[2];
const podspecFilePath = 'pubspec.yaml';
let podspecData = fs.readFileSync(podspecFilePath, "utf8");
console.log(podspecData);
console.log(podspecData.match(/version: \d*\.\d*\.\d*/g));

const oldVersion = podspecData.match(/version: \d*\.\d*\.\d*/g)[0].split(':')[1].trim().replaceAll('"', '');
const iOSVersionFilePath = 'ios/Classes/Constants.swift';
const androidVersionFilePath = 'android/src/main/java/com/letscooee/flutter/utils/Constants.java';

if (!newVersion) {
    console.log('Please specify a version number/updater');
    return;
}

if (newVersion === 'patch') {
    newVersion = updatePatch(oldVersion);
} else if (newVersion === 'minor') {
    newVersion = updateMinor(oldVersion);
} else if (newVersion === 'major') {
    newVersion = updateMajor(oldVersion);
} else if (!isValidVersion(newVersion)) {
    console.log('Please specify a valid argument - patch|minor|major|<version>');
    console.log('Check:\n\tnode publish.js patch|minor|major|<version>');
    console.log('parameter:\n' +
        '\tpatch: update patch version i.e 1.0.0 -> 1.0.1\n' +
        '\tminor: update minor version i.e 1.0.0 -> 1.1.0\n' +
        '\tmajor: update major version i.e 1.0.0 -> 2.0.0\n' +
        '\t<version>: valid version string in 1.1.1 format\n');
    return;
}

console.log(`updating [${oldVersion}] --> [${newVersion}]`);
const newVersionCode = parseInt(newVersion.split('.').map(v => v.padStart(2, '0')).join(''));

podspecData = podspecData.replace(/version: \d*\.\d*\.\d*/g, `version: ${newVersion}`);
fs.writeFileSync(podspecFilePath, podspecData);

bumpVersionInNativeFiles(iOSVersionFilePath);
bumpVersionInNativeFiles(androidVersionFilePath);

function bumpVersionInNativeFiles(path){
    let cooeeMetaData = fs.readFileSync(path, "utf8");
    cooeeMetaData = cooeeMetaData.replace(/VERSION_NAME = "[^"]+"/, `VERSION_NAME = "${newVersion}"`);
    if(path.includes('android')){
        cooeeMetaData = cooeeMetaData.replace(/VERSION_CODE = [^\n]+/, `VERSION_CODE = ${newVersionCode};`);
    }else{
        cooeeMetaData = cooeeMetaData.replace(/VERSION_CODE = [^\n]+/, `VERSION_CODE = ${newVersionCode}`);
    }
    fs.writeFileSync(path, cooeeMetaData);
}

/**
 * Update patch version
 *
 * @param oldVersion {string} old version string
 * @returns {string} new version string
 */
function updatePatch(oldVersion) {
    let newVersionArr = oldVersion.split('.');
    newVersionArr[2] = parseInt(newVersionArr[2]) + 1;
    return newVersionArr.join('.');
}

/**
 * Update minor version
 *
 * @param oldVersion {string} old version string
 * @returns {string} new version string
 */
function updateMinor(oldVersion) {
    let newVersionArr = oldVersion.split('.');
    newVersionArr[1] = parseInt(newVersionArr[1]) + 1;
    newVersionArr[2] = 0;
    return newVersionArr.join('.');
}

/**
 * Update major version
 *
 * @param oldVersion {string} old version string
 * @returns {string} new version string
 */
function updateMajor(oldVersion) {
    let majorVersion = oldVersion.split('.')[0];
    majorVersion = parseInt(majorVersion) + 1;
    return `${majorVersion}.0.0`;
}