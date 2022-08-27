const { curly } = require('node-libcurl');

async function get ( url) {
	const { statusCode, data, headers } = await curly.get(url);
	return (statusCode, data, headers);
}

async function main () {
const { statusCode, data, headers } = await get('https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/case.sh');
console.log(data);
}

main();
