"use strict";

function Sortable(container){
  var I = this;                           // I for "Instance"
  I.container     = container;
  I.$container    = $(container);
  I.$cachedEls    = {}
  I.isAscending   = true;
  I.attrs         = {
    record        : "data-record",        // input
    recordNumber  : "data-record-number", // output
    recordsTotal  : "data-records-total", // output
    sortTrigger   : "data-sort-trigger",  // input
    sortField     : "data-sort-field",    // input
    isSorting     : "data-is-sorting",    // output
    filterable    : "data-filterable",    // input
    isFiltering   : "data-is-filtering",  // output
    filterTrigger : "data-filter-trigger",// input
    filterInput   : "data-filter-input",  // input
    hidden        : "data-hidden",        // output
    isAscending   : "data-is-ascending"   // output
  }
}
Sortable.prototype = (function setPrototype(){
  var InstanceMethods = {};

  InstanceMethods.activate = function(){  // Sets row numbers and adds listeners
    var I = this;
    I.attrs["_"] = {};                                  // _ looks kinda like []
    $.each(I.attrs, function setBracketedAttrs(name, attribute){
      I.attrs._[name] = "[" + attribute + "]";
    });
    I.records = I.findAndCache("record");
    if(I.records.length > 0){
      I.findAndCache("sortTrigger").on("click", sortTrigger.bind(I));
      I.findAndCache("filterInput").on("keyup", filterInput.bind(I));
      I.findAndCache("filterTrigger").on("click", filterTrigger.bind(I));
    }
    I.numberRecords();
  }

  InstanceMethods.filterOn = function(value){
    var I = this;
    var regex = new RegExp(value, "i");
    I.container.setAttribute(I.attrs.isFiltering, "true");
    $.each(I.records, function(index, record){
      if(record.text.match(regex)){
        record.hidden = false;
        record.el.removeAttribute(I.attrs.hidden);
      }else{
        record.hidden = true;
        record.el.setAttribute(I.attrs.hidden, "true");
      }
    });
    I.numberRecords();
  }

  InstanceMethods.filterOff = function(){
    var I = this;
    I.container.removeAttribute(I.attrs.isFiltering);
    $.each(I.records, function(index, record){
      record.hidden = false;
      record.el.removeAttribute(I.attrs.hidden);
    });
    I.numberRecords();
  }

  InstanceMethods.findAndCache = function(selector){
    var I = this, el;
    if(!I.$cachedEls[selector]){                        // Caches jQuery queries
      I.$cachedEls[selector] = I.$container.find(I.attrs._[selector]);
    }
    return I.$cachedEls[selector];
  }

  InstanceMethods.loadRecords = function(){
    var I = this;
    I.records = [];
    I.recordsLoaded = true;
    I.findAndCache("record").each(function(index, el){
      var $el     = $(el);
      var record  = {
        el:     el,
        text:   "",
        fields: []
      };
      $el.find(I.attrs._.filterable).each(function(i, el){
        record.text += el.textContent.trim();   // += text of filterable records
      });
      $el.find(I.attrs._.sortField).each(function(i, el){
        var field = el.getAttribute(I.attrs.sortField);
        record.fields[field] = el.textContent;
      });
      I.records.push(record);
    });
  }

  InstanceMethods.numberRecords = function(){
    var I = this;
    var totalRecords = 0;
    $.each(I.records, function(index, record){
      var el = (record instanceof HTMLElement ? record : record.el);
      if(!record.hidden){     // When page loads records are HTML els. Then, are
        totalRecords += 1;                   // object literals that contain els
        $(el).find(I.attrs._.recordNumber).text(totalRecords);
      }
    });
    I.findAndCache("recordsTotal").text(totalRecords);
  }

  InstanceMethods.sortOn = function(field){
    var I = this;
    var parent = I.records[0].el.parentElement;
    I.isAscending = !(I.isAscending);
    I.container.setAttribute(I.attrs.isAscending, I.isAscending);
    I.records.sort(function(recordA, recordB){
      var data = [recordA.fields[field], recordB.fields[field]];
      $.each(data, function(index, datum){
        data[index] = getSortableData(datum);
      });
      return compareData(data, I.isAscending);
    });
    $.each(I.records, function(index, record){
      $(record.el).detach();
      $(parent).append(record.el);
    });
    I.numberRecords();
  }

  function sortTrigger(event){
    var I = this;
    var el = event.target;
    var value = el.getAttribute(I.attrs.sortTrigger);
    if(!I.recordsLoaded) I.loadRecords();                        // Lazy loading
    I.$container.find(I.attrs._.isSorting).removeAttr(I.attrs.isSorting);
    el.setAttribute(I.attrs.isSorting, "true");
    I.sortOn(value);
  }

  function filterInput(event){
    var I = this;
    var el = event.target;
    var value = el.value;
    if(!I.recordsLoaded) I.loadRecords();
    if(value.length > 1 ) I.filterOn(value);   // Filter not triggered on 1 char
    else I.filterOff();
  }

  function filterTrigger(event){
    var I = this;
    var el = event.target;
    var value = el.getAttribute(I.attrs.filterTrigger);
    if(!I.recordsLoaded) I.loadRecords();
    I.findAndCache("filterInput")[0].value = value;
    I.filterOn(value);
  }

  function getSortableData(text){   // Convert text to date or float if possible
    var num = parseFloat(text);
    if(isNaN(num)) num = new Date(text).getTime();
    if(isNaN(num)) return text;
    else return num;
  }

  function compareData(data, ascending){
    var out;                                 // Text should come before non-text
    if(isNaN(data[0]) && !isNaN(data[1])) out = -1;
    else if(!isNaN(data[0]) && isNaN(data[1])) out = 1;
    else out = (data[0] > data[1]) ? 1 : -1;
    return (ascending ? out : 0 - out);
  }

  return InstanceMethods;
})();
