const fs = require('fs');
const child = require("child_process");

const pubspecFilePath = 'pubspec.yaml';
const iOSVersionFilePath = 'ios/Classes/Constants.swift';
const androidVersionFilePath = 'android/src/main/java/com/letscooee/flutter/utils/Constants.java';
let newVersion = process.argv[2];

/**************** Find Old Version ***************/
let pubspecData = fs.readFileSync(pubspecFilePath, "utf8");
const oldVersion = pubspecData.match(/version: \d*\.\d*\.\d*/g)[0].split(':')[1].trim().replaceAll('"', '');
/**************** End Find Old Version ***************/

if (!newVersion) {
    console.log('Please specify a version number/updater');
    return;
}

/**************** Bump Version ***************/
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
/**************** End Bump Version ***************/

console.log(`updating [${oldVersion}] --> [${newVersion}]`);
const newVersionCode = parseInt(newVersion.split('.').map(v => v.padStart(2, '0')).join(''));

/**************** Write New Version in pubspec.yaml ***************/
pubspecData = pubspecData.replace(/version: \d*\.\d*\.\d*/g, `version: ${newVersion}`);
fs.writeFileSync(pubspecFilePath, pubspecData);
/**************** End Write New Version in pubspec.yaml ***************/

/**************** Write New Version in Constant.java & Constant.swift ***************/
bumpVersionInNativeFiles(iOSVersionFilePath);
bumpVersionInNativeFiles(androidVersionFilePath);
/**************** End Write New Version in pubspec.yaml ***************/

/**
 * Access file at given path and write VERSION_NAME & VERSION_CODE
 *
 * @param path {string} path of the file
 */
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