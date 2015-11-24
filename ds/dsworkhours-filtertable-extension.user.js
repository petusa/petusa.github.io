// ==UserScript==
// @name         dsworkhours-filtertable-extension
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Extends the filter table with week colored wek days column, and duration. This yields better visualization over your real activities.
// @author       Peter Nagy
// @require      https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.6.15/browser-polyfill.min.js
// @require      https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.6.15/browser.min.js
// @require      https://gist.github.com/raw/2625891/waitForKeyElements.js
// @require      https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.min.js
// @require      https://cdnjs.cloudflare.com/ajax/libs/randomcolor/0.4.1/randomColor.js
// @match        http://dsworkhours.appspot.com/
// ==/UserScript==

/* jshint ignore:start */
var inline_src = (<><![CDATA[
/* jshint ignore:end */
/* jshint esnext:true */

                    
/* jshint ignore:start */
var mainTable;
    var foundMainTable = false;
    var startColumn;
    var endColumn;
    var dateColumn;
    waitForKeyElements("table tr", (tr) => {
        mainTable = tr[0].parentNode.parentNode;
        if (foundMainTable === true && mainTable.id === "filterTable"){
            decorateTableRow(tr[0]);
        }
        if (!foundMainTable && tr[0].parentNode.nodeName ==="THEAD") {
            mainTable = tr[0].parentNode.parentNode;
            console.dir(mainTable);
            if (!mainTable.id){
                mainTable.id = "filterTable";
                foundMainTable = true;
                dateColumn = tr[0].cells[0];
                startColumn = tr[0].cells[1];
                endColumn = tr[0].cells[2];
                tr[0].insertCell(0).innerHTML = "Duration";
                tr[0].insertCell(0).innerHTML = "Day";
                Array.from(tr[0].cells).forEach((cell, index) => {
                    cell.className = `h_${index}`
                });
                addStyles();
                addFontAwesome();
            }
        }        
    });

    var DAYS = ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
    var DAY_COLORS = randomColor({
        luminosity: 'light',
        format: 'rgb', // e.g. 'rgb(225,200,20)',
        count: 7,
        seed: 39
    });

    function decorateTableRow(tr){
        let v = Array.from(tr.cells).map(cell => cell.firstChild.data);
        let date = v[0];
        let start = v[1];
        let end = v[2];
        let day = moment(date, "YYYY.MM.DD").weekday();
        let duration = moment(end, "HH:MM").diff(moment(start, "HH:MM"));
        let dHour = moment.utc(duration).get("hour");
        let dMinute = moment.utc(duration).get("minute");
        let formattedDuration = `${dHour}h : ${dMinute}m`
        console.log(`end: ${end} start: ${start} date: ${date} duration: ${formattedDuration}`);
        // add duration cell
        tr.insertCell(0).innerHTML = formattedDuration;
        // add day cell
        let DayCell = tr.insertCell(0);
        DayCell.innerHTML = DAYS[day-1];
        // add column class for cells
        Array.from(tr.cells).forEach((cell, index) => cell.className = `c_${index}`);
        // add extra cell classes
        DayCell.className += ` ${DAYS[day-1]}`;
    }

    // TODO style generation could be nicer, static styles, as well as for hide/show styles
    function addStyles(){
        let css = document.createElement('style');
        css.type = 'text/css';
        css.id = 'columnStyles';
        let styles = `#filterTable .c_3, #filterTable .c_4, #filterTable .c_6, #filterTable .h_3, #filterTable .h_4, #filterTable .h_6 { display:none }
#filterTable .c_0.M { background-color: ${DAY_COLORS[0]} }
#filterTable .c_0.Tu { background-color: ${DAY_COLORS[1]} }
#filterTable .c_0.W { background-color: ${DAY_COLORS[2]} }
#filterTable .c_0.Th { background-color: ${DAY_COLORS[3]} }
#filterTable .c_0.F { background-color: ${DAY_COLORS[4]} }
#filterTable .c_0.Sa { background-color: ${DAY_COLORS[5]} }
#filterTable .c_0.Su { background-color: ${DAY_COLORS[6]} }
#filterTable .c_0 { font-family: FontAwesome; color: white; text-align: center; vertical-align: middle; }
#filterTable .c_1 { font-family: FontAwesome; color: black; text-align: center; vertical-align: middle; }
`;

        if (css.styleSheet) {
            css.styleSheet.cssText = styles;
        } else {
            css.appendChild(document.createTextNode(styles));
        }
        document.getElementsByTagName("head")[0].appendChild(css);
    }

    function addFontAwesome(){
        let css = document.createElement('link');
        css.rel = 'stylesheet';
        css.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.css';
        document.getElementsByTagName("head")[0].appendChild(css);
    }

]]></>).toString();
var c = babel.transform(inline_src);
eval(c.code);
/* jshint ignore:end */
