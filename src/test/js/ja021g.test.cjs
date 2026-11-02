const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const html=fs.readFileSync('src/main/resources/templates/views/subscriptionrights/w_ja021g.html','utf8');
const js=html.match(/<script th:inline="javascript">([\s\S]*?)<\/script>/)[1];
new vm.Script(js);
const grids=new Map(),requests=[],notices=[];
const classes=()=>({toggle(){},add(){}});
const buttons=Array.from({length:7},(_,i)=>({dataset:{tab:'t'+(i+1)},classList:classes(),setAttribute(){},addEventListener(_,fn){this.click=fn;}}));
const pages=buttons.map(b=>({id:'ja021g-pane-'+b.dataset.tab,classList:classes()}));
const elements=new Map();
for(const button of buttons)for(const kind of ['master','detail']){
 const id='ja021g-'+kind+'-'+button.dataset.tab;
 elements.set('#'+id,{id});
}
for(const page of pages)elements.set('#'+page.id,page);
const copy={classList:classes()},refresh={};
const view={dataset:{workDate:'2026-10-29',corpGr:'2402'},isConnected:true,
 querySelector:s=>s==='.btn-copy'?copy:s==='.btn-refresh'?refresh:elements.get(s),
 querySelectorAll:s=>s==='[role=tab]'?buttons:pages,addEventListener(){}};
class Row{
 constructor(grid,data){this.grid=grid;this.data=structuredClone(data);}
 getData(){return this.data;}
 update(patch){Object.assign(this.data,patch);return Promise.resolve();}
 getElement(){return {classList:classes()};}
 getPosition(){return this.grid.rows.indexOf(this)+1;}
 select(){this.grid.selected=this;}
 delete(){this.grid.rows=this.grid.rows.filter(row=>row!==this);return Promise.resolve();}
}
class Table{
 constructor(el,options){this.el=el;this.options=options;this.rows=[];this.events={};grids.set(el.id,this);
  setImmediate(()=>{this.built=true;this.events.tableBuilt?.();});}
 on(event,fn){this.events[event]=fn;}
 redraw(){assert.equal(this.built,true,'redraw must wait for tableBuilt');}
 setData(data){assert.equal(this.built,true);this.rows=data.map(d=>new Row(this,d));return Promise.resolve();}
 clearData(){this.rows=[];return Promise.resolve();}
 getData(){return this.rows.map(r=>r.getData());}
 getRows(){return this.rows;}
 getSelectedRows(){return this.selected?[this.selected]:[];}
 deselectRow(){this.selected=null;}
 addRow(data){const row=new Row(this,data);this.rows.unshift(row);return Promise.resolve(row);}
 download(){}
}
const codes=['G40','G43','G45','G47','G60','G92','G93'];
const context={document:{currentScript:{closest:()=>view},readyState:'complete',querySelector:()=>null},
 Tabulator:Table,URLSearchParams,console,confirm:()=>true,alert:message=>notices.push(message),
 showToast:message=>notices.push(message),formatDateVal:v=>v,aamsDateEditor(){},aamsNumberFormatter(){},aamsCellEdit(){},
 DynamicCodeSearch:{openModal:opts=>opts.onSelect('11111','검색회사')},
 AamsCalendar:{openDatePicker:opts=>opts.onSelect('2026-11-02')},
 AamsSplitter:{init:page=>{for(const [id,grid] of grids)if(id.endsWith(page.id.slice(-2)))assert.equal(grid.built,true);}},
 fetch:async(url,options)=>{
  requests.push({url,options});
  const parsed=new URL(url,'http://localhost'),tab=parsed.searchParams.get('tab')||'t1';
  const master={trYmd:'2026-10-30',trCd:codes[Number(tab.slice(1))-1],habCo:'12345',piHabCo:'54321'};
  master.original={...master};
  const detail={...master,corpGr:'2402',fundCd:'F1',oldJmCd:'OLD',newJmCd:'NEW',typeTrench:'X',bsType:1,habJusu:10};
  return {ok:true,json:async()=>url.includes('/save')?{success:true}:url.includes('/detail')?[detail]:[master]};
 }};
context.window=context;
vm.runInNewContext(js,context);
const settle=async()=>{for(let i=0;i<12;i++)await new Promise(setImmediate);};
(async()=>{
 await settle();
 assert.equal(grids.size,2);
 assert.equal(requests.filter(r=>r.url.includes('/data')).length,1);
 for(let i=1;i<7;i++){buttons[i].click();await settle();}
 assert.equal(grids.size,14);
 assert.equal(requests.filter(r=>r.url.includes('/data')).length,7);
 assert.equal(requests.filter(r=>r.url.includes('/detail')).length,7);
 const detail=grids.get('ja021g-detail-t7'),row=detail.rows[0];
 await row.update({habJusu:25});
 detail.events.cellEdited({getRow:()=>row,getField:()=>'habJusu'});
 buttons[0].click();await settle();
 buttons[6].click();await settle();
 await view.onSave();
 const saved=requests.find(r=>r.url.includes('/save'));
 assert.equal(JSON.parse(saved.options.body).tab,'t7');
 assert.equal(JSON.parse(saved.options.body).detail[0].habJusu,25,'detail changes survive tab switch even when Tabulator copies input rows');
 await view.onInput();await settle();
 const master=grids.get('ja021g-master-t7'),newRow=master.rows[0];
 assert.equal(newRow.getData().trCd,'G93');
 const search=master.options.columns.find(c=>c.field==='p_xx_piHabCo');
 search.cellClick({stopPropagation(){}},{getData:()=>newRow.getData(),getRow:()=>newRow});
 await settle();
 assert.equal(newRow.getData().habCo,'11111');
 assert.equal(newRow.getData().isUpdated,true);
 const cal=master.options.columns.find(c=>c.field==='p_dd_trYmd');
 cal.cellClick({stopPropagation(){}},{getData:()=>newRow.getData(),getRow:()=>newRow,getElement:()=>({})});
 await settle();
 assert.equal(newRow.getData().trYmd,'2026-11-02');
 assert.equal(copy.disabled,true);
 assert.equal(notices.filter(n=>String(n).includes('오류')).length,0);
 console.log('PASS: 7 tabs auto-query; tableBuilt ordering; detail persistence/save; input/search/calendar; copy restriction.');
})().catch(error=>{console.error(error);process.exitCode=1;});
