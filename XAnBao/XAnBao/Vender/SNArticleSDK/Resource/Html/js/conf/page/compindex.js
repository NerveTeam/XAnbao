/**
 * @fileoverview ECMA-SCRIPT兼容处理
 * @desc 仅留存了移动端低版本设备可能存在兼容性问题的函数
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('lib/more/es5-safe',function(require,exports,module){

  // es5-safe
  // ----------------
  // Provides compatibility shims so that legacy JavaScript engines behave as
  // closely as possible to ES5.
  //
  // Thanks to:
  //  - http://es5.github.com/
  //  - http://kangax.github.com/es5-compat-table/
  //  - https://github.com/kriskowal/es5-shim
  //  - http://perfectionkills.com/extending-built-in-native-objects-evil-or-not/
  //  - https://gist.github.com/1120592
  //  - https://code.google.com/p/v8/


  var OP = Object.prototype;
  var AP = Array.prototype;
  var FP = Function.prototype;
  var SP = String.prototype;
  var hasOwnProperty = OP.hasOwnProperty;
  var slice = AP.slice;


  /*---------------------------------------*
   * Function
   *---------------------------------------*/

  // ES-5 15.3.4.5
  // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind
  FP.bind || (FP.bind = function(that) {
    var target = this;

    // If IsCallable(func) is false, throw a TypeError exception.
    if (typeof target !== 'function') {
      throw new TypeError('Bind must be called on a function');
    }

    var boundArgs = slice.call(arguments, 1);

    function bound() {
      // Called as a constructor.
      if (this instanceof bound) {
        var self = createObject(target.prototype);
        var result = target.apply(
            self,
            boundArgs.concat(slice.call(arguments))
        );
        return Object(result) === result ? result : self;
      }
      // Called as a function.
      else {
        return target.apply(
            that,
            boundArgs.concat(slice.call(arguments))
        );
      }
    }

    // NOTICE: The function.length is not writable.
    //bound.length = Math.max(target.length - boundArgs.length, 0);

    return bound;
  });

  /*---------------------------------------*
   * Array
   *---------------------------------------*/
  // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array
  // https://github.com/kangax/fabric.js/blob/gh-pages/src/util/lang_array.js

  // ES5 15.4.4.21
  // https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Objects/Array/reduce
  AP.reduce || (AP.reduce = function(fn /*, initial*/) {
    if (typeof fn !== 'function') {
      throw new TypeError(fn + ' is not an function');
    }

    var len = this.length >>> 0, i = 0, result;

    if (arguments.length > 1) {
      result = arguments[1];
    }
    else {
      do {
        if (i in this) {
          result = this[i++];
          break;
        }
        // if array contains no values, no initial value to return
        if (++i >= len) {
          throw new TypeError('reduce of empty array with on initial value');
        }
      }
      while (true);
    }

    for (; i < len; i++) {
      if (i in this) {
        result = fn.call(null, result, this[i], i, this);
      }
    }

    return result;
  });

  /*---------------------------------------*
   * String
   *---------------------------------------*/

  // ES5 15.5.4.20
  // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/String/trim
  // http://blog.stevenlevithan.com/archives/faster-trim-javascript
  // http://jsperf.com/mega-trim-test
  SP.trim || (SP.trim = (function() {

    // http://perfectionkills.com/whitespace-deviations/
    var whiteSpaces = [

      '\\s',
      //'0009', // 'HORIZONTAL TAB'
      //'000A', // 'LINE FEED OR NEW LINE'
      //'000B', // 'VERTICAL TAB'
      //'000C', // 'FORM FEED'
      //'000D', // 'CARRIAGE RETURN'
      //'0020', // 'SPACE'

      '00A0', // 'NO-BREAK SPACE'
      '1680', // 'OGHAM SPACE MARK'
      '180E', // 'MONGOLIAN VOWEL SEPARATOR'

      '2000-\\u200A',
      //'2000', // 'EN QUAD'
      //'2001', // 'EM QUAD'
      //'2002', // 'EN SPACE'
      //'2003', // 'EM SPACE'
      //'2004', // 'THREE-PER-EM SPACE'
      //'2005', // 'FOUR-PER-EM SPACE'
      //'2006', // 'SIX-PER-EM SPACE'
      //'2007', // 'FIGURE SPACE'
      //'2008', // 'PUNCTUATION SPACE'
      //'2009', // 'THIN SPACE'
      //'200A', // 'HAIR SPACE'

      '200B', // 'ZERO WIDTH SPACE (category Cf)
      '2028', // 'LINE SEPARATOR'
      '2029', // 'PARAGRAPH SEPARATOR'
      '202F', // 'NARROW NO-BREAK SPACE'
      '205F', // 'MEDIUM MATHEMATICAL SPACE'
      '3000' //  'IDEOGRAPHIC SPACE'

    ].join('\\u');

    var trimLeftReg = new RegExp('^[' + whiteSpaces + ']+');
    var trimRightReg = new RegExp('[' + whiteSpaces + ']+$');

    return function() {
      return String(this).replace(trimLeftReg, '').replace(trimRightReg, '');
    }

  })());


  /*---------------------------------------*
   * Date
   *---------------------------------------*/

  // ES5 15.9.4.4
  // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Date/now
  Date.now || (Date.now = function() {
    return +new Date;
  });

});


/**
 * @fileoverview zepto lib 混合文件 
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/core/chaos/zepto',function(require,exports,module){

	//zepto modules
	var Zepto = require('lib/core/zepto/zepto');
	require('lib/core/zepto/event');
	require('lib/core/zepto/touch');
	require('lib/core/zepto/ajax');

	//zepto plugin
	require('lib/core/extra/zepto/zepto');
	require('lib/core/extra/zepto/prefixfree');
	require('lib/core/extra/zepto/transform');
	require('lib/core/extra/zepto/transit');

	module.exports = Zepto;

});



/**
 * @fileoverview 基础工厂元件类
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/mvc/base',function(require,exports,module){
	var $ = require('lib');
	var $class = require('lib/more/class');
	var $events = require('lib/more/events');

	var Base = $class.create({
		Implements : [$events],
		//类的默认值，不要在实例中修改这个对象
		defaults : {},
		initialize : function(options){
			this.setOptions(options);
			this.build();
			this.setEvents('on');
		},
		setOptions : function(options){
			this.conf = this.conf || $.extend(true, {}, this.defaults);
			if(!$.isPlainObject(options)){
				options = {};
			}
			$.extend(true, this.conf, options);
		},
		//初始化，构建
		build : $.noop,
		setEvents : $.noop,
		//代理函数
		proxy : function(name){
			var that = this;
			var bound = this.bound ? this.bound : this.bound = {};
			name = name || 'proxy';
			if(!$.isFunction(bound[name])){
				bound[name] = function(){
					if($.isFunction(that[name])){
						return that[name].apply(that, arguments);
					}
				};
			}
			return bound[name];
		},
		destroy : function(){
			this.setEvents('off');
			this.off();
			this.bound = null;
		}
	});

	module.exports = Base;

});


/**
 * @fileoverview 基本模型
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/mvc/model',function(require,exports,module){
	var $ = require('lib');
	var $base = require('lib/mvc/base');
	var $delegate = require('lib/mvc/delegate');

	//私有原型名称
	var PRIVATE_NAME = '__private__';

	//为类的data对象设置可监控属性
	//param {String} key 属性名称
	//param {Mixed} value 属性值
	var setAttr = function(key, value){
		if($.type(key)!=='string'){return;}
		var that = this;
		var data = this.data || {};
		if(!data.hasOwnProperty(PRIVATE_NAME)){
			Object.defineProperty(data, PRIVATE_NAME, {
				writable:true,
				enumerable:false,
				configurable:true
			});
			data[PRIVATE_NAME] = {};
		}
		if(!data.hasOwnProperty(key)){
			Object.defineProperty(data, key, {
				set : function(val){
					var prevValue = this[key];
					if(val !== prevValue){
						this[PRIVATE_NAME][key] = val;
						that.changed = true;
						that.trigger('change:' + key, prevValue);
					}
				},
				get : function(){
					return this[PRIVATE_NAME][key];
				},
				// A property cannot both have accessors and be writable or have a value
				enumerable:true,
				configurable:true
			});
			this.changed = true;
		}
		data[key] = value;
	};

	//为类的data对象设置可计算属性
	//param {String} key 属性名称
	//param {Function} fn 属性计算函数
	var setComputedAttr = function(key, fn){
		if($.type(key)!=='string'){return;}
		var that = this;
		var data = this.data || {};
		setAttr.call(this, key);
		Object.defineProperty(data, key, {
			get : function(){
				return fn.call(that, this[PRIVATE_NAME][key]);
			}
		});
	};

	//为类的data对象清除属性
	//param {String} key 属性名称
	var removeAttr = function(key){
		delete this.data[key];
	};

	var Model = $base.extend({
		defaults : {},
		events : {},
		initialize : function(options){
			this.data = {};
			this.changed = false;
			Model.superclass.initialize.apply(this,arguments);
		},
		//配置选项与模型
		setOptions : function(options){
			Model.superclass.setOptions.apply(this,arguments);
			this.set(this.conf);
		},
		//model的事件应当仅用于自身属性的关联运算
		setEvents : function(action){
			this.delegate(action);
		},
		//代理自身事件
		delegate : function(action, root, events, bind){
			action = action || 'on';
			root = root || this;
			events = events || this.events;
			bind = bind || this;
			$delegate(action, root, events, bind);
		},
		//设置模型的属性
		//将会触发change事件
		//会触发针对每个属性的 change:propname 事件
		set : function(key, val){
			if($.isPlainObject(key)){
				$.each(key, setAttr.bind(this));
			}else if($.type(key) === 'string'){
				setAttr.call(this, key, val);
			}
			if(this.changed){
				this.trigger('change');
				this.changed = false;
			}
		},
		//获取模型对应属性的值的拷贝
		//如果不传参数，则直接获取整个模型数据
		get : function(key){
			var value;
			if($.type(key) === 'string'){
				value = this.data[key];
				if($.isPlainObject(value)){
					return $.extend(true, {}, value);
				}else if($.isArray(value)){
					return $.extend(true, [], value);
				}else{
					return value;
				}
			}
			if(typeof key === 'undefined'){
				return $.extend(true, {}, this.data);
			}
		},
		//设置自动计算属性
		//注意：自动计算属性不会因为自动计算而触发 change 事件
		setComputed : function(key, fn){
			if($.type(key) === 'object'){
				$.each(key, setComputedAttr.bind(this));
			}else if($.type(key) === 'string' && $.isFunction(fn)){
				setComputedAttr.call(this, key, fn);
			}
		},
		//获取模型上设置的所有键名
		keys : function(){
			return Object.keys(this.data);
		},
		//删除模型上的一个键
		remove : function(key){
			removeAttr.call(this, key);
			this.trigger('change:' + key);
			this.trigger('change');
		},
		//清除模型中所有数据
		clear : function(){
			Object.keys(this.data).forEach(this.remove, this);
		},
		destroy : function(){
			this.changed = false;
			Model.superclass.destroy.apply(this,arguments);
			this.clear();
			this.data = null;
		}
	});

	module.exports = Model;

});


/**
 * @fileoverview 基本视图
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/mvc/view',function(require,exports,module){
	var $ = require('lib');
	var $base = require('lib/mvc/base');
	var $delegate = require('lib/mvc/delegate');

	//获取视图的根节点
	var getRoot = function(){
		var conf = this.conf;
		var template = conf.template;
		var nodes = this.nodes;
		var root = nodes.root;
		if(!root){
			if(conf.node){
				root = $(conf.node);
			}
			if(!root || !root.length){
				if($.isArray(template)){
					template = template.join('');
				}
				root = $(template);
			}
			nodes.root = root;
		}
		return root;
	};

	var View = $base.extend({
		defaults : {
			node : '',
			template : '',
			events : {},
			role : {}
		},
		initialize : function(options){
			this.nodes = {};
			View.superclass.initialize.apply(this,arguments);
		},
		setEvents : function(action){
			this.delegate(action);
		},
		delegate : function(action, root, events, bind){
			action = action || 'on';
			root = root || this.role('root');
			events = events || this.conf.events;
			bind = bind || this;
			$delegate(action, root, events, bind);
		},
		//获取 / 设置角色元素的jquery对象
		//注意：获取到角色元素后，该jquery对象会缓存在视图对象中
		role : function(name, element){
			var nodes = this.nodes;
			var root = getRoot.call(this);
			var role = this.conf.role || {};
			if(!element){
				if(nodes[name]){
					element = nodes[name];
				}
				if(name === 'root'){
					element = root;
				}else if(!element || !element.length){
					if(role[name]){
						element = root.find(role[name]);
					}else{
						element = root.find('[data-role="' + name + '"]');
					}
					nodes[name] = element;
				}
			}else{
				nodes[name] = element = $(element);
			}
			return element;
		},
		//清除视图缓存的角色dom元素
		resetRoles : function(){
			var nodes = this.nodes;
			$.each(nodes, function(name){
				if(name !== 'root'){
					nodes[name] = null;
					delete nodes[name];
				}
			});
		},
		destroy : function(){
			View.superclass.destroy.apply(this,arguments);
			this.resetRoles();
			this.nodes = null;
		}
	});

	module.exports = View;

});


/**
 * @fileoverview 事件对象绑定
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/mvc/delegate', function(require,exports,module) {

	//method delegate 将events中包含的键值对映射为代理的事件
	//param {Boolean} action 开/关代理 ['on', 'off']。
	//param {Element} root 设置代理的根节点，应该是一个jquery对象。
	//param {Object} events 事件键值对，格式可以为：
	//	{'selector event':'method'}
	//  {'event':'method'}
	//  {'selector event':'method1 method2'}
	//  {'event':'method1 method2'}
	//param {Object} bind 指定事件函数绑定的对象。
	module.exports = function(action, root, events, bind){
		var proxy, delegate;
		if(!root){return;}
		if(!bind || !$.isFunction(bind.proxy)){return;}

		proxy = bind.proxy();
		action = action === 'on' ? 'on' : 'off';
		delegate = action === 'on' ? 'delegate' : 'undelegate';
		events = $.extend({}, events);

		$.each(events, function(handle, method){
			var selector, event, fns = [];
			handle = handle.split(/\s+/);
			if($.type(method) === 'string'){
				fns = method.split(/\s+/).map(function(fname){
					return proxy(fname);
				});
			}else if($.isFunction(method)){
				fns = [method];
			}else{
				return;
			}
			event = handle.pop();
			if(handle.length >= 1){
				selector = handle.join(' ');
				if($.isFunction(root[delegate])){
					fns.forEach(function(fn){
						root[delegate](selector, event, fn);
					});
				}
			}else{
				if($.isFunction(root[action])){
					fns.forEach(function(fn){
						root[action](event, fn);
					});
				}
			}
		});

	};
});


/**
 * @fileoverview JSON与参数串的切换
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('lib/more/querystring', function(require,exports,module) {

  // QueryString
  // ---------------
  // This module provides utilities for dealing with query strings.
  //
  // Thanks to:
  //  - http://nodejs.org/docs/v0.4.7/api/querystring.html
  //  - http://developer.yahoo.com/yui/3/api/QueryString.html


  var QueryString = {};


  // The escape/unescape function used by stringify/parse, provided so that it
  // could be overridden if necessary. This is important in cases where
  // non-standard delimiters are used, if the delimiters would not normally be
  // handled properly by the built-in (en|de)codeURIComponent functions.
  QueryString.escape = encodeURIComponent;

  QueryString.unescape = function(s) {
    // The + character is interpreted as a space on the server side as well as
    // generated by forms with spaces in their fields.
    return decodeURIComponent(s.replace(/\+/g, ' '));
  };


  /**
   * Serialize an object to a query string. Optionally override the default
   * separator and assignment characters.
   *
   * stringify({foo: 'bar'})
   *   // returns 'foo=bar'
   *
   * stringify({foo: 'bar', baz: 'bob'}, ';', ':')
   *   // returns 'foo:bar;baz:bob'
   */
  QueryString.stringify = function(obj, sep, eq, arrayKey) {
    if (!isPlainObject(obj)) return '';

    sep = sep || '&';
    eq = eq || '=';
    arrayKey = arrayKey || false;

    var buf = [], key, val;
    var escape = QueryString.escape;

    for (key in obj) {
      if (!hasOwnProperty.call(obj, key)) continue;

      val = obj[key];
      key = QueryString.escape(key);

      // val is primitive value
      if (isPrimitive(val)) {
        buf.push(key, eq, escape(val + ''), sep);
      }
      // val is not empty array
      else if (isArray(val) && val.length) {
        for (var i = 0; i < val.length; i++) {
          if (isPrimitive(val[i])) {
            buf.push(
                key,
                (arrayKey ? escape('[]') : '') + eq,
                escape(val[i] + ''),
                sep);
          }
        }
      }
      // ignore other cases, including empty array, Function, RegExp, Date etc.
      else {
        buf.push(key, eq, sep);
      }
    }

    buf.pop();
    return buf.join('');
  };


  /**
   * Deserialize a query string to an object. Optionally override the default
   * separator and assignment characters.
   *
   * parse('a=b&c=d')
   *   // returns {a: 'b', c: 'c'}
   */
  QueryString.parse = function(str, sep, eq) {
    var ret = {};

    if (typeof str !== 'string' || trim(str).length === 0) {
      return ret;
    }

    var pairs = str.split(sep || '&');
    eq = eq || '=';
    var unescape = QueryString.unescape;

    for (var i = 0; i < pairs.length; i++) {

      var pair = pairs[i].split(eq);
      var key = unescape(trim(pair[0]));
      var val = unescape(trim(pair.slice(1).join(eq)));

      var m = key.match(/^(\w+)\[\]$/);
      if (m && m[1]) {
        key = m[1];
      }

      if (hasOwnProperty.call(ret, key)) {
        if (!isArray(ret[key])) {
          ret[key] = [ret[key]];
        }
        ret[key].push(val);
      }
      else {
        ret[key] = m ? [val] : val;
      }
    }

    return ret;
  };


  // Helpers

  var toString = Object.prototype.toString;
  var hasOwnProperty = Object.prototype.hasOwnProperty;
  var isArray = Array.isArray || function(val) {
    return toString.call(val) === '[object Array]';
  };
  var trim = String.prototype.trim ?
      function(str) {
        return (str == null) ?
            '' :
            String.prototype.trim.call(str);
      } :
      function(str) {
        return (str == null) ?
            '' :
            str.toString().replace(/^\s+/, '').replace(/\s+$/, '');
      };


  /**
   * Checks to see if an object is a plain object (created using "{}" or
   * "new Object()" or "new FunctionClass()").
   */
  function isPlainObject(o) {
    /**
     * NOTES:
     * isPlainObject(node = document.getElementById("xx")) -> false
     * toString.call(node):
     *   ie678 === '[object Object]', other === '[object HTMLElement]'
     * 'isPrototypeOf' in node:
     *   ie678 === false, other === true
     */
    return o &&
        toString.call(o) === '[object Object]' &&
        'isPrototypeOf' in o;
  }


  /**
   * If the type of o is null, undefined, number, string, boolean,
   * return true.
   */
  function isPrimitive(o) {
    return o !== Object(o);
  }

  module.exports = QueryString;

});


/**
 * @fileoverview html渲染组件的lithe模块封装，作为与全局对象的接口定义组件
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/common/htmlRender',function(require,exports,module){

	var htmlRender = window.htmlRender || {};
	if($.type(htmlRender.ready) !== 'function'){
		htmlRender.ready = function(fn){
			if($.type(fn) === 'function'){
				fn();
			}
		};
	}

	[
		'renderItem'
	].forEach(function(methodName){
		htmlRender[methodName] = htmlRender[methodName] || $.noop;
	});

	module.exports = htmlRender;

});



/**
 * @fileoverview 广播组件
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/common/listener',function(require,exports,module){

	var $ = require('lib');
	var $events = require('lib/more/events');
	// Listener
	// -----------------
	// 用于全局广播的白名单控制机制

	var Listener = function(events){
		this._whiteList = {};
		this._receiver = new $events();
		if(Array.isArray(events)){
			events.forEach(this.define.bind(this));
		}
	};

	//事件添加，移除，激发的调用方法参考Events
	Listener.prototype = {
		constructor : Listener,
		//在白名单上定义一个事件名称
		define : function(eventName){
			this._whiteList[eventName] = true;
		},
		//取消白名单上的事件名称
		undefine : function(eventName){
			delete this._whiteList[eventName];
		},
		on : function(){
			this._receiver.on.apply(this._receiver, arguments);
		},
		off : function(){
			this._receiver.off.apply(this._receiver, arguments);
		},
		trigger : function(events){
			var rest = [].slice.call(arguments, 1);

			//按照Events.trigger的调用方式，第一个参数是用空格分隔的事件名称列表
			events = events.split(/\s+/);

			//遍历事件列表，依据白名单决定事件是否激发
			events.forEach(function(evtName){
				if(this._whiteList[evtName]){
					this._receiver.trigger.apply(this._receiver, [evtName].concat(rest));
				}
			}.bind(this));
		}
	};

	module.exports = Listener;

});

/**
 * @fileoverview 封装与客户端的交互方式
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 * @example
	var $jsbridge = require('lib/common/jsbridge');
	var bridge = new $jsbridge([
		'clientMethod1',
		'clientMethod2',
		'clientMethod3'
	]);

	//简单的调用方法，不传递数据
	bridge.request('clientMethod1');

	//简单的调用方法，传递数据
	bridge.request('clientMethod2', {
		data : {
			a : 1,
			b : 2
		}
	});

	//传递数据，并要求一个回调
	bridge.request('clientMethod3', {
		data : {
			a : 1,
			b : 2
		},
		callback : function(rs){
			//get callback json : rs
		}
	});

	//注册一个广播事件
	//addEventListener默认就在白名单内
	bridge.request('addEventListener', {
		event : 'render',
		callback : 'window.listener.trigger("render", [data])'
	});
 */

define('lib/common/jsbridge',function(require,exports,module){

	var $ = require('lib');
	var $getUniqueKey = require('lib/kit/util/getUniqueKey');

	var $win = window;

	var PREFIX = 'jsbridge';
	var CALLBACK_NAME = '_callback_';
	var PROTOCOL = 'jsbridge://';

	var container;

	//封装要传递到客户端的数据
	var getPostMessage = function(conf, name){
		var message;

		//与客户端约定，callback属性必须是一个字符串
		if(conf.callback && $.type(conf.callback) === 'function'){
			$win[CALLBACK_NAME + name] = conf.callback;
			//[data]为一个占位符，客户端会将其替换为一个JSON对象
			conf.callback = 'try{window["' + CALLBACK_NAME + name + '"]([data]);}catch(e){}';
		}else if($.type(conf.callback) !== 'string'){
			delete conf.callback;
		}

		//客户端不需要timeout属性
		delete conf.timeout;

		try{
			//客户端读取到的实际上是一个JSON字符串
			message = JSON.stringify(conf);
		}catch(e){
			console.error('JSON stringify ' + name + ' error!');
		}finally{
			if(window.console && console.info && lithe.debug){
				console.info('jsBridge send:', conf);
			}
		}

		return message;
	};

	var jsBridge = function(whitelist){
		this.whitelist = {
			'addEventListener' : true
		};
		if($.isArray(whitelist)){
			whitelist.forEach(this.define.bind(this));
		}
	};

	var iframeRequest = function(src){
		if(!container){
			container = $('<div></div>').hide().appendTo(document.body);
		}
	
		var iframe = $(document.createElement('iframe'));
		iframe.attr('src', src);
		iframe.hide().appendTo(container);

		return iframe;
	};

	//提供白名单机制, 要求项目中维护白名单，以增强项目可维护性
	jsBridge.prototype = {
		define : function(name){
			this.whitelist[name] = true;
		},
		undefine : function(name){
			delete this.whitelist[name];
		},
		request : function(method, spec){
			var conf = $.extend({
				//单位(ms)，这个时间之后，会销毁全局变量与iframe，释放内存
				timeout : 3 * 1000,
				onTimeout : $.noop
			}, spec);

			if(!method){return;}
			if(!this.whitelist[method]){return;}
			conf.method = method;
			//此处为了清除创建的iframe资源，不允许超时为0；
			var timeout = conf.timeout || 3 * 1000;
			var name = PREFIX + $getUniqueKey();
			var src = PROTOCOL + name;
			var message = getPostMessage(conf, name);
			var iframe;
			
			//客户端可以暴露一个对象接收数据
			//规范接收数据的对象名称为:jsBridge, 方法名称为:process
			if(
				$win.jsBridge &&
				$.isFunction($win.jsBridge.process)
			){
				//存在客户端暴露的方法，直接调用该方法传递数据
				$win.jsBridge.process(message);
			}else{
				//不存在客户端暴露的方法，则暴露一个全局变量，用iframe.src通知客户端来读取
				$win[name] = message;
				iframe = iframeRequest(src);
			}

			setTimeout(function(){
				delete $win[name];
				delete $win[CALLBACK_NAME + name];
				if(iframe && iframe.remove){
					iframe.remove();
				}
				if($.type(conf.onTimeout) === 'function'){
					conf.onTimeout();
				}
			}, timeout);
		}
	};

	module.exports = jsBridge;

});

define('lib/core/zepto/zepto',function(require,exports,module){

//     Zepto.js
//     (c) 2010-2014 Thomas Fuchs
//     Zepto.js may be freely distributed under the MIT license.

var Zepto = (function() {
  var undefined, key, $, classList, emptyArray = [], slice = emptyArray.slice, filter = emptyArray.filter,
    document = window.document,
    elementDisplay = {}, classCache = {},
    cssNumber = { 'column-count': 1, 'columns': 1, 'font-weight': 1, 'line-height': 1,'opacity': 1, 'z-index': 1, 'zoom': 1 },
    fragmentRE = /^\s*<(\w+|!)[^>]*>/,
    singleTagRE = /^<(\w+)\s*\/?>(?:<\/\1>|)$/,
    tagExpanderRE = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/ig,
    rootNodeRE = /^(?:body|html)$/i,
    capitalRE = /([A-Z])/g,

    // special attributes that should be get/set via method calls
    methodAttributes = ['val', 'css', 'html', 'text', 'data', 'width', 'height', 'offset'],

    adjacencyOperators = [ 'after', 'prepend', 'before', 'append' ],
    table = document.createElement('table'),
    tableRow = document.createElement('tr'),
    containers = {
      'tr': document.createElement('tbody'),
      'tbody': table, 'thead': table, 'tfoot': table,
      'td': tableRow, 'th': tableRow,
      '*': document.createElement('div')
    },
    readyRE = /complete|loaded|interactive/,
    simpleSelectorRE = /^[\w-]*$/,
    class2type = {},
    toString = class2type.toString,
    zepto = {},
    camelize, uniq,
    tempParent = document.createElement('div'),
    propMap = {
      'tabindex': 'tabIndex',
      'readonly': 'readOnly',
      'for': 'htmlFor',
      'class': 'className',
      'maxlength': 'maxLength',
      'cellspacing': 'cellSpacing',
      'cellpadding': 'cellPadding',
      'rowspan': 'rowSpan',
      'colspan': 'colSpan',
      'usemap': 'useMap',
      'frameborder': 'frameBorder',
      'contenteditable': 'contentEditable'
    },
    isArray = Array.isArray ||
      function(object){ return object instanceof Array }

  zepto.matches = function(element, selector) {
    if (!selector || !element || element.nodeType !== 1) return false
    var matchesSelector = element.webkitMatchesSelector || element.mozMatchesSelector ||
                          element.oMatchesSelector || element.matchesSelector
    if (matchesSelector) return matchesSelector.call(element, selector)
    // fall back to performing a selector:
    var match, parent = element.parentNode, temp = !parent
    if (temp) (parent = tempParent).appendChild(element)
    match = ~zepto.qsa(parent, selector).indexOf(element)
    temp && tempParent.removeChild(element)
    return match
  }

  function type(obj) {
    return obj == null ? String(obj) :
      class2type[toString.call(obj)] || "object"
  }

  function isFunction(value) { return type(value) == "function" }
  function isWindow(obj)     { return obj != null && obj == obj.window }
  function isDocument(obj)   { return obj != null && obj.nodeType == obj.DOCUMENT_NODE }
  function isObject(obj)     { return type(obj) == "object" }
  function isPlainObject(obj) {
    return isObject(obj) && !isWindow(obj) && Object.getPrototypeOf(obj) == Object.prototype
  }
  function likeArray(obj) { return typeof obj.length == 'number' }

  function compact(array) { return filter.call(array, function(item){ return item != null }) }
  function flatten(array) { return array.length > 0 ? $.fn.concat.apply([], array) : array }
  camelize = function(str){ return str.replace(/-+(.)?/g, function(match, chr){ return chr ? chr.toUpperCase() : '' }) }
  function dasherize(str) {
    return str.replace(/::/g, '/')
           .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
           .replace(/([a-z\d])([A-Z])/g, '$1_$2')
           .replace(/_/g, '-')
           .toLowerCase()
  }
  uniq = function(array){ return filter.call(array, function(item, idx){ return array.indexOf(item) == idx }) }

  function classRE(name) {
    return name in classCache ?
      classCache[name] : (classCache[name] = new RegExp('(^|\\s)' + name + '(\\s|$)'))
  }

  function maybeAddPx(name, value) {
    return (typeof value == "number" && !cssNumber[dasherize(name)]) ? value + "px" : value
  }

  function defaultDisplay(nodeName) {
    var element, display
    if (!elementDisplay[nodeName]) {
      element = document.createElement(nodeName)
      document.body.appendChild(element)
      display = getComputedStyle(element, '').getPropertyValue("display")
      element.parentNode.removeChild(element)
      display == "none" && (display = "block")
      elementDisplay[nodeName] = display
    }
    return elementDisplay[nodeName]
  }

  function children(element) {
    return 'children' in element ?
      slice.call(element.children) :
      $.map(element.childNodes, function(node){ if (node.nodeType == 1) return node })
  }

  // `$.zepto.fragment` takes a html string and an optional tag name
  // to generate DOM nodes nodes from the given html string.
  // The generated DOM nodes are returned as an array.
  // This function can be overriden in plugins for example to make
  // it compatible with browsers that don't support the DOM fully.
  zepto.fragment = function(html, name, properties) {
    var dom, nodes, container

    // A special case optimization for a single tag
    if (singleTagRE.test(html)) dom = $(document.createElement(RegExp.$1))

    if (!dom) {
      if (html.replace) html = html.replace(tagExpanderRE, "<$1></$2>")
      if (name === undefined) name = fragmentRE.test(html) && RegExp.$1
      if (!(name in containers)) name = '*'

      container = containers[name]
      container.innerHTML = '' + html
      dom = $.each(slice.call(container.childNodes), function(){
        container.removeChild(this)
      })
    }

    if (isPlainObject(properties)) {
      nodes = $(dom)
      $.each(properties, function(key, value) {
        if (methodAttributes.indexOf(key) > -1) nodes[key](value)
        else nodes.attr(key, value)
      })
    }

    return dom
  }

  // `$.zepto.Z` swaps out the prototype of the given `dom` array
  // of nodes with `$.fn` and thus supplying all the Zepto functions
  // to the array. Note that `__proto__` is not supported on Internet
  // Explorer. This method can be overriden in plugins.
  zepto.Z = function(dom, selector) {
    dom = dom || []
    dom.__proto__ = $.fn
    dom.selector = selector || ''
    return dom
  }

  // `$.zepto.isZ` should return `true` if the given object is a Zepto
  // collection. This method can be overriden in plugins.
  zepto.isZ = function(object) {
    return object instanceof zepto.Z
  }

  // `$.zepto.init` is Zepto's counterpart to jQuery's `$.fn.init` and
  // takes a CSS selector and an optional context (and handles various
  // special cases).
  // This method can be overriden in plugins.
  zepto.init = function(selector, context) {
    var dom
    // If nothing given, return an empty Zepto collection
    if (!selector) return zepto.Z()
    // Optimize for string selectors
    else if (typeof selector == 'string') {
      selector = selector.trim()
      // If it's a html fragment, create nodes from it
      // Note: In both Chrome 21 and Firefox 15, DOM error 12
      // is thrown if the fragment doesn't begin with <
      if (selector[0] == '<' && fragmentRE.test(selector))
        dom = zepto.fragment(selector, RegExp.$1, context), selector = null
      // If there's a context, create a collection on that context first, and select
      // nodes from there
      else if (context !== undefined) return $(context).find(selector)
      // If it's a CSS selector, use it to select nodes.
      else dom = zepto.qsa(document, selector)
    }
    // If a function is given, call it when the DOM is ready
    else if (isFunction(selector)) return $(document).ready(selector)
    // If a Zepto collection is given, just return it
    else if (zepto.isZ(selector)) return selector
    else {
      // normalize array if an array of nodes is given
      if (isArray(selector)) dom = compact(selector)
      // Wrap DOM nodes.
      else if (isObject(selector))
        dom = [selector], selector = null
      // If it's a html fragment, create nodes from it
      else if (fragmentRE.test(selector))
        dom = zepto.fragment(selector.trim(), RegExp.$1, context), selector = null
      // If there's a context, create a collection on that context first, and select
      // nodes from there
      else if (context !== undefined) return $(context).find(selector)
      // And last but no least, if it's a CSS selector, use it to select nodes.
      else dom = zepto.qsa(document, selector)
    }
    // create a new Zepto collection from the nodes found
    return zepto.Z(dom, selector)
  }

  // `$` will be the base `Zepto` object. When calling this
  // function just call `$.zepto.init, which makes the implementation
  // details of selecting nodes and creating Zepto collections
  // patchable in plugins.
  $ = function(selector, context){
    return zepto.init(selector, context)
  }

  function extend(target, source, deep) {
    for (key in source)
      if (deep && (isPlainObject(source[key]) || isArray(source[key]))) {
        if (isPlainObject(source[key]) && !isPlainObject(target[key]))
          target[key] = {}
        if (isArray(source[key]) && !isArray(target[key]))
          target[key] = []
        extend(target[key], source[key], deep)
      }
      else if (source[key] !== undefined) target[key] = source[key]
  }

  // Copy all but undefined properties from one or more
  // objects to the `target` object.
  $.extend = function(target){
    var deep, args = slice.call(arguments, 1)
    if (typeof target == 'boolean') {
      deep = target
      target = args.shift()
    }
    args.forEach(function(arg){ extend(target, arg, deep) })
    return target
  }

  // `$.zepto.qsa` is Zepto's CSS selector implementation which
  // uses `document.querySelectorAll` and optimizes for some special cases, like `#id`.
  // This method can be overriden in plugins.
  zepto.qsa = function(element, selector){
    var found,
        maybeID = selector[0] == '#',
        maybeClass = !maybeID && selector[0] == '.',
        nameOnly = maybeID || maybeClass ? selector.slice(1) : selector, // Ensure that a 1 char tag name still gets checked
        isSimple = simpleSelectorRE.test(nameOnly)
    return (isDocument(element) && isSimple && maybeID) ?
      ( (found = element.getElementById(nameOnly)) ? [found] : [] ) :
      (element.nodeType !== 1 && element.nodeType !== 9) ? [] :
      slice.call(
        isSimple && !maybeID ?
          maybeClass ? element.getElementsByClassName(nameOnly) : // If it's simple, it could be a class
          element.getElementsByTagName(selector) : // Or a tag
          element.querySelectorAll(selector) // Or it's not simple, and we need to query all
      )
  }

  function filtered(nodes, selector) {
    return selector == null ? $(nodes) : $(nodes).filter(selector)
  }

  $.contains = function(parent, node) {
    return parent !== node && parent.contains(node)
  }

  function funcArg(context, arg, idx, payload) {
    return isFunction(arg) ? arg.call(context, idx, payload) : arg
  }

  function setAttribute(node, name, value) {
    value == null ? node.removeAttribute(name) : node.setAttribute(name, value)
  }

  // access className property while respecting SVGAnimatedString
  function className(node, value){
    var klass = node.className,
        svg   = klass && klass.baseVal !== undefined

    if (value === undefined) return svg ? klass.baseVal : klass
    svg ? (klass.baseVal = value) : (node.className = value)
  }

  // "true"  => true
  // "false" => false
  // "null"  => null
  // "42"    => 42
  // "42.5"  => 42.5
  // "08"    => "08"
  // JSON    => parse if valid
  // String  => self
  function deserializeValue(value) {
    var num
    try {
      return value ?
        value == "true" ||
        ( value == "false" ? false :
          value == "null" ? null :
          !/^0/.test(value) && !isNaN(num = Number(value)) ? num :
          /^[\[\{]/.test(value) ? $.parseJSON(value) :
          value )
        : value
    } catch(e) {
      return value
    }
  }

  $.type = type
  $.isFunction = isFunction
  $.isWindow = isWindow
  $.isArray = isArray
  $.isPlainObject = isPlainObject

  $.isEmptyObject = function(obj) {
    var name
    for (name in obj) return false
    return true
  }

  $.inArray = function(elem, array, i){
    return emptyArray.indexOf.call(array, elem, i)
  }

  $.camelCase = camelize
  $.trim = function(str) {
    return str == null ? "" : String.prototype.trim.call(str)
  }

  // plugin compatibility
  $.uuid = 0
  $.support = { }
  $.expr = { }

  $.map = function(elements, callback){
    var value, values = [], i, key
    if (likeArray(elements))
      for (i = 0; i < elements.length; i++) {
        value = callback(elements[i], i)
        if (value != null) values.push(value)
      }
    else
      for (key in elements) {
        value = callback(elements[key], key)
        if (value != null) values.push(value)
      }
    return flatten(values)
  }

  $.each = function(elements, callback){
    var i, key
    if (likeArray(elements)) {
      for (i = 0; i < elements.length; i++)
        if (callback.call(elements[i], i, elements[i]) === false) return elements
    } else {
      for (key in elements)
        if (callback.call(elements[key], key, elements[key]) === false) return elements
    }

    return elements
  }

  $.grep = function(elements, callback){
    return filter.call(elements, callback)
  }

  if (window.JSON) $.parseJSON = JSON.parse

  // Populate the class2type map
  $.each("Boolean Number String Function Array Date RegExp Object Error".split(" "), function(i, name) {
    class2type[ "[object " + name + "]" ] = name.toLowerCase()
  })

  // Define methods that will be available on all
  // Zepto collections
  $.fn = {
    // Because a collection acts like an array
    // copy over these useful array functions.
    forEach: emptyArray.forEach,
    reduce: emptyArray.reduce,
    push: emptyArray.push,
    sort: emptyArray.sort,
    indexOf: emptyArray.indexOf,
    concat: emptyArray.concat,

    // `map` and `slice` in the jQuery API work differently
    // from their array counterparts
    map: function(fn){
      return $($.map(this, function(el, i){ return fn.call(el, i, el) }))
    },
    slice: function(){
      return $(slice.apply(this, arguments))
    },

    ready: function(callback){
      // need to check if document.body exists for IE as that browser reports
      // document ready when it hasn't yet created the body element
      if (readyRE.test(document.readyState) && document.body) callback($)
      else document.addEventListener('DOMContentLoaded', function(){ callback($) }, false)
      return this
    },
    get: function(idx){
      return idx === undefined ? slice.call(this) : this[idx >= 0 ? idx : idx + this.length]
    },
    toArray: function(){ return this.get() },
    size: function(){
      return this.length
    },
    remove: function(){
      return this.each(function(){
        if (this.parentNode != null)
          this.parentNode.removeChild(this)
      })
    },
    each: function(callback){
      emptyArray.every.call(this, function(el, idx){
        return callback.call(el, idx, el) !== false
      })
      return this
    },
    filter: function(selector){
      if (isFunction(selector)) return this.not(this.not(selector))
      return $(filter.call(this, function(element){
        return zepto.matches(element, selector)
      }))
    },
    add: function(selector,context){
      return $(uniq(this.concat($(selector,context))))
    },
    is: function(selector){
      return this.length > 0 && zepto.matches(this[0], selector)
    },
    not: function(selector){
      var nodes=[]
      if (isFunction(selector) && selector.call !== undefined)
        this.each(function(idx){
          if (!selector.call(this,idx)) nodes.push(this)
        })
      else {
        var excludes = typeof selector == 'string' ? this.filter(selector) :
          (likeArray(selector) && isFunction(selector.item)) ? slice.call(selector) : $(selector)
        this.forEach(function(el){
          if (excludes.indexOf(el) < 0) nodes.push(el)
        })
      }
      return $(nodes)
    },
    has: function(selector){
      return this.filter(function(){
        return isObject(selector) ?
          $.contains(this, selector) :
          $(this).find(selector).size()
      })
    },
    eq: function(idx){
      return idx === -1 ? this.slice(idx) : this.slice(idx, + idx + 1)
    },
    first: function(){
      var el = this[0]
      return el && !isObject(el) ? el : $(el)
    },
    last: function(){
      var el = this[this.length - 1]
      return el && !isObject(el) ? el : $(el)
    },
    find: function(selector){
      var result, $this = this
      if (typeof selector == 'object')
        result = $(selector).filter(function(){
          var node = this
          return emptyArray.some.call($this, function(parent){
            return $.contains(parent, node)
          })
        })
      else if (this.length == 1) result = $(zepto.qsa(this[0], selector))
      else result = this.map(function(){ return zepto.qsa(this, selector) })
      return result
    },
    closest: function(selector, context){
      var node = this[0], collection = false
      if (typeof selector == 'object') collection = $(selector)
      while (node && !(collection ? collection.indexOf(node) >= 0 : zepto.matches(node, selector)))
        node = node !== context && !isDocument(node) && node.parentNode
      return $(node)
    },
    parents: function(selector){
      var ancestors = [], nodes = this
      while (nodes.length > 0)
        nodes = $.map(nodes, function(node){
          if ((node = node.parentNode) && !isDocument(node) && ancestors.indexOf(node) < 0) {
            ancestors.push(node)
            return node
          }
        })
      return filtered(ancestors, selector)
    },
    parent: function(selector){
      return filtered(uniq(this.pluck('parentNode')), selector)
    },
    children: function(selector){
      return filtered(this.map(function(){ return children(this) }), selector)
    },
    contents: function() {
      return this.map(function() { return slice.call(this.childNodes) })
    },
    siblings: function(selector){
      return filtered(this.map(function(i, el){
        return filter.call(children(el.parentNode), function(child){ return child!==el })
      }), selector)
    },
    empty: function(){
      return this.each(function(){ this.innerHTML = '' })
    },
    // `pluck` is borrowed from Prototype.js
    pluck: function(property){
      return $.map(this, function(el){ return el[property] })
    },
    show: function(){
      return this.each(function(){
        this.style.display == "none" && (this.style.display = '')
        if (getComputedStyle(this, '').getPropertyValue("display") == "none")
          this.style.display = defaultDisplay(this.nodeName)
      })
    },
    replaceWith: function(newContent){
      return this.before(newContent).remove()
    },
    wrap: function(structure){
      var func = isFunction(structure)
      if (this[0] && !func)
        var dom   = $(structure).get(0),
            clone = dom.parentNode || this.length > 1

      return this.each(function(index){
        $(this).wrapAll(
          func ? structure.call(this, index) :
            clone ? dom.cloneNode(true) : dom
        )
      })
    },
    wrapAll: function(structure){
      if (this[0]) {
        $(this[0]).before(structure = $(structure))
        var children
        // drill down to the inmost element
        while ((children = structure.children()).length) structure = children.first()
        $(structure).append(this)
      }
      return this
    },
    wrapInner: function(structure){
      var func = isFunction(structure)
      return this.each(function(index){
        var self = $(this), contents = self.contents(),
            dom  = func ? structure.call(this, index) : structure
        contents.length ? contents.wrapAll(dom) : self.append(dom)
      })
    },
    unwrap: function(){
      this.parent().each(function(){
        $(this).replaceWith($(this).children())
      })
      return this
    },
    clone: function(){
      return this.map(function(){ return this.cloneNode(true) })
    },
    hide: function(){
      return this.css("display", "none")
    },
    toggle: function(setting){
      return this.each(function(){
        var el = $(this)
        ;(setting === undefined ? el.css("display") == "none" : setting) ? el.show() : el.hide()
      })
    },
    prev: function(selector){ return $(this.pluck('previousElementSibling')).filter(selector || '*') },
    next: function(selector){ return $(this.pluck('nextElementSibling')).filter(selector || '*') },
    html: function(html){
      return arguments.length === 0 ?
        (this.length > 0 ? this[0].innerHTML : null) :
        this.each(function(idx){
          var originHtml = this.innerHTML
          $(this).empty().append( funcArg(this, html, idx, originHtml) )
        })
    },
    text: function(text){
      return arguments.length === 0 ?
        (this.length > 0 ? this[0].textContent : null) :
        this.each(function(){ this.textContent = (text === undefined) ? '' : ''+text })
    },
    attr: function(name, value){
      var result
      return (typeof name == 'string' && value === undefined) ?
        (this.length == 0 || this[0].nodeType !== 1 ? undefined :
          (name == 'value' && this[0].nodeName == 'INPUT') ? this.val() :
          (!(result = this[0].getAttribute(name)) && name in this[0]) ? this[0][name] : result
        ) :
        this.each(function(idx){
          if (this.nodeType !== 1) return
          if (isObject(name)) for (key in name) setAttribute(this, key, name[key])
          else setAttribute(this, name, funcArg(this, value, idx, this.getAttribute(name)))
        })
    },
    removeAttr: function(name){
      return this.each(function(){ this.nodeType === 1 && setAttribute(this, name) })
    },
    prop: function(name, value){
      name = propMap[name] || name
      return (value === undefined) ?
        (this[0] && this[0][name]) :
        this.each(function(idx){
          this[name] = funcArg(this, value, idx, this[name])
        })
    },
    data: function(name, value){
      var data = this.attr('data-' + name.replace(capitalRE, '-$1').toLowerCase(), value)
      return data !== null ? deserializeValue(data) : undefined
    },
    val: function(value){
      return arguments.length === 0 ?
        (this[0] && (this[0].multiple ?
           $(this[0]).find('option').filter(function(){ return this.selected }).pluck('value') :
           this[0].value)
        ) :
        this.each(function(idx){
          this.value = funcArg(this, value, idx, this.value)
        })
    },
    offset: function(coordinates){
      if (coordinates) return this.each(function(index){
        var $this = $(this),
            coords = funcArg(this, coordinates, index, $this.offset()),
            parentOffset = $this.offsetParent().offset(),
            props = {
              top:  coords.top  - parentOffset.top,
              left: coords.left - parentOffset.left
            }

        if ($this.css('position') == 'static') props['position'] = 'relative'
        $this.css(props)
      })
      if (this.length==0) return null
      var obj = this[0].getBoundingClientRect()
      return {
        left: obj.left + window.pageXOffset,
        top: obj.top + window.pageYOffset,
        width: Math.round(obj.width),
        height: Math.round(obj.height)
      }
    },
    css: function(property, value){
      if (arguments.length < 2) {
        var element = this[0], computedStyle = getComputedStyle(element, '')
        if(!element) return
        if (typeof property == 'string')
          return element.style[camelize(property)] || computedStyle.getPropertyValue(property)
        else if (isArray(property)) {
          var props = {}
          $.each(isArray(property) ? property: [property], function(_, prop){
            props[prop] = (element.style[camelize(prop)] || computedStyle.getPropertyValue(prop))
          })
          return props
        }
      }

      var css = ''
      if (type(property) == 'string') {
        if (!value && value !== 0)
          this.each(function(){ this.style.removeProperty(dasherize(property)) })
        else
          css = dasherize(property) + ":" + maybeAddPx(property, value)
      } else {
        for (key in property)
          if (!property[key] && property[key] !== 0)
            this.each(function(){ this.style.removeProperty(dasherize(key)) })
          else
            css += dasherize(key) + ':' + maybeAddPx(key, property[key]) + ';'
      }

      return this.each(function(){ this.style.cssText += ';' + css })
    },
    index: function(element){
      return element ? this.indexOf($(element)[0]) : this.parent().children().indexOf(this[0])
    },
    hasClass: function(name){
      if (!name) return false
      return emptyArray.some.call(this, function(el){
        return this.test(className(el))
      }, classRE(name))
    },
    addClass: function(name){
      if (!name) return this
      return this.each(function(idx){
        classList = []
        var cls = className(this), newName = funcArg(this, name, idx, cls)
        newName.split(/\s+/g).forEach(function(klass){
          if (!$(this).hasClass(klass)) classList.push(klass)
        }, this)
        classList.length && className(this, cls + (cls ? " " : "") + classList.join(" "))
      })
    },
    removeClass: function(name){
      return this.each(function(idx){
        if (name === undefined) return className(this, '')
        classList = className(this)
        funcArg(this, name, idx, classList).split(/\s+/g).forEach(function(klass){
          classList = classList.replace(classRE(klass), " ")
        })
        className(this, classList.trim())
      })
    },
    toggleClass: function(name, when){
      if (!name) return this
      return this.each(function(idx){
        var $this = $(this), names = funcArg(this, name, idx, className(this))
        names.split(/\s+/g).forEach(function(klass){
          (when === undefined ? !$this.hasClass(klass) : when) ?
            $this.addClass(klass) : $this.removeClass(klass)
        })
      })
    },
    scrollTop: function(value){
      if (!this.length) return
      var hasScrollTop = 'scrollTop' in this[0]
      if (value === undefined) return hasScrollTop ? this[0].scrollTop : this[0].pageYOffset
      return this.each(hasScrollTop ?
        function(){ this.scrollTop = value } :
        function(){ this.scrollTo(this.scrollX, value) })
    },
    scrollLeft: function(value){
      if (!this.length) return
      var hasScrollLeft = 'scrollLeft' in this[0]
      if (value === undefined) return hasScrollLeft ? this[0].scrollLeft : this[0].pageXOffset
      return this.each(hasScrollLeft ?
        function(){ this.scrollLeft = value } :
        function(){ this.scrollTo(value, this.scrollY) })
    },
    position: function() {
      if (!this.length) return

      var elem = this[0],
        // Get *real* offsetParent
        offsetParent = this.offsetParent(),
        // Get correct offsets
        offset       = this.offset(),
        parentOffset = rootNodeRE.test(offsetParent[0].nodeName) ? { top: 0, left: 0 } : offsetParent.offset()

      // Subtract element margins
      // note: when an element has margin: auto the offsetLeft and marginLeft
      // are the same in Safari causing offset.left to incorrectly be 0
      offset.top  -= parseFloat( $(elem).css('margin-top') ) || 0
      offset.left -= parseFloat( $(elem).css('margin-left') ) || 0

      // Add offsetParent borders
      parentOffset.top  += parseFloat( $(offsetParent[0]).css('border-top-width') ) || 0
      parentOffset.left += parseFloat( $(offsetParent[0]).css('border-left-width') ) || 0

      // Subtract the two offsets
      return {
        top:  offset.top  - parentOffset.top,
        left: offset.left - parentOffset.left
      }
    },
    offsetParent: function() {
      return this.map(function(){
        var parent = this.offsetParent || document.body
        while (parent && !rootNodeRE.test(parent.nodeName) && $(parent).css("position") == "static")
          parent = parent.offsetParent
        return parent
      })
    }
  }

  // for now
  $.fn.detach = $.fn.remove

  // Generate the `width` and `height` functions
  ;['width', 'height'].forEach(function(dimension){
    var dimensionProperty =
      dimension.replace(/./, function(m){ return m[0].toUpperCase() })

    $.fn[dimension] = function(value){
      var offset, el = this[0]
      if (value === undefined) return isWindow(el) ? el['inner' + dimensionProperty] :
        isDocument(el) ? el.documentElement['scroll' + dimensionProperty] :
        (offset = this.offset()) && offset[dimension]
      else return this.each(function(idx){
        el = $(this)
        el.css(dimension, funcArg(this, value, idx, el[dimension]()))
      })
    }
  })

  function traverseNode(node, fun) {
    fun(node)
    for (var key in node.childNodes) traverseNode(node.childNodes[key], fun)
  }

  // Generate the `after`, `prepend`, `before`, `append`,
  // `insertAfter`, `insertBefore`, `appendTo`, and `prependTo` methods.
  adjacencyOperators.forEach(function(operator, operatorIndex) {
    var inside = operatorIndex % 2 //=> prepend, append

    $.fn[operator] = function(){
      // arguments can be nodes, arrays of nodes, Zepto objects and HTML strings
      var argType, nodes = $.map(arguments, function(arg) {
            argType = type(arg)
            return argType == "object" || argType == "array" || arg == null ?
              arg : zepto.fragment(arg)
          }),
          parent, copyByClone = this.length > 1
      if (nodes.length < 1) return this

      return this.each(function(_, target){
        parent = inside ? target : target.parentNode

        // convert all methods to a "before" operation
        target = operatorIndex == 0 ? target.nextSibling :
                 operatorIndex == 1 ? target.firstChild :
                 operatorIndex == 2 ? target :
                 null

        nodes.forEach(function(node){
          if (copyByClone) node = node.cloneNode(true)
          else if (!parent) return $(node).remove()

          traverseNode(parent.insertBefore(node, target), function(el){
            if (el.nodeName != null && el.nodeName.toUpperCase() === 'SCRIPT' &&
               (!el.type || el.type === 'text/javascript') && !el.src)
              window['eval'].call(window, el.innerHTML)
          })
        })
      })
    }

    // after    => insertAfter
    // prepend  => prependTo
    // before   => insertBefore
    // append   => appendTo
    $.fn[inside ? operator+'To' : 'insert'+(operatorIndex ? 'Before' : 'After')] = function(html){
      $(html)[operator](this)
      return this
    }
  })

  zepto.Z.prototype = $.fn

  // Export internal API functions in the `$.zepto` namespace
  zepto.uniq = uniq
  zepto.deserializeValue = deserializeValue
  $.zepto = zepto

  return $
})()

// If `$` is not yet defined, point it to `Zepto`
window.Zepto = Zepto
window.$ === undefined && (window.$ = Zepto)

module.exports = Zepto;

});


define('lib/core/zepto/event',function(require,exports,module){

  var $ = require('lib/core/zepto/zepto');
//     Zepto.js
//     (c) 2010-2014 Thomas Fuchs
//     Zepto.js may be freely distributed under the MIT license.

  var _zid = 1, undefined,
      slice = Array.prototype.slice,
      isFunction = $.isFunction,
      isString = function(obj){ return typeof obj == 'string' },
      handlers = {},
      specialEvents={},
      focusinSupported = 'onfocusin' in window,
      focus = { focus: 'focusin', blur: 'focusout' },
      hover = { mouseenter: 'mouseover', mouseleave: 'mouseout' }

  specialEvents.click = specialEvents.mousedown = specialEvents.mouseup = specialEvents.mousemove = 'MouseEvents'

  function zid(element) {
    return element._zid || (element._zid = _zid++)
  }
  function findHandlers(element, event, fn, selector) {
    event = parse(event)
    if (event.ns) var matcher = matcherFor(event.ns)
    return (handlers[zid(element)] || []).filter(function(handler) {
      return handler
        && (!event.e  || handler.e == event.e)
        && (!event.ns || matcher.test(handler.ns))
        && (!fn       || zid(handler.fn) === zid(fn))
        && (!selector || handler.sel == selector)
    })
  }
  function parse(event) {
    var parts = ('' + event).split('.')
    return {e: parts[0], ns: parts.slice(1).sort().join(' ')}
  }
  function matcherFor(ns) {
    return new RegExp('(?:^| )' + ns.replace(' ', ' .* ?') + '(?: |$)')
  }

  function eventCapture(handler, captureSetting) {
    return handler.del &&
      (!focusinSupported && (handler.e in focus)) ||
      !!captureSetting
  }

  function realEvent(type) {
    return hover[type] || (focusinSupported && focus[type]) || type
  }

  function add(element, events, fn, data, selector, delegator, capture){
    var id = zid(element), set = (handlers[id] || (handlers[id] = []))
    events.split(/\s/).forEach(function(event){
      if (event == 'ready') return $(document).ready(fn)
      var handler   = parse(event)
      handler.fn    = fn
      handler.sel   = selector
      // emulate mouseenter, mouseleave
      if (handler.e in hover) fn = function(e){
        var related = e.relatedTarget
        if (!related || (related !== this && !$.contains(this, related)))
          return handler.fn.apply(this, arguments)
      }
      handler.del   = delegator
      var callback  = delegator || fn
      handler.proxy = function(e){
        e = compatible(e)
        if (e.isImmediatePropagationStopped()) return
        e.data = data
        var result = callback.apply(element, e._args == undefined ? [e] : [e].concat(e._args))
        if (result === false) e.preventDefault(), e.stopPropagation()
        return result
      }
      handler.i = set.length
      set.push(handler)
      if ('addEventListener' in element)
        element.addEventListener(realEvent(handler.e), handler.proxy, eventCapture(handler, capture))
    })
  }
  function remove(element, events, fn, selector, capture){
    var id = zid(element)
    ;(events || '').split(/\s/).forEach(function(event){
      findHandlers(element, event, fn, selector).forEach(function(handler){
        delete handlers[id][handler.i]
      if ('removeEventListener' in element)
        element.removeEventListener(realEvent(handler.e), handler.proxy, eventCapture(handler, capture))
      })
    })
  }

  $.event = { add: add, remove: remove }

  $.proxy = function(fn, context) {
    if (isFunction(fn)) {
      var proxyFn = function(){ return fn.apply(context, arguments) }
      proxyFn._zid = zid(fn)
      return proxyFn
    } else if (isString(context)) {
      return $.proxy(fn[context], fn)
    } else {
      throw new TypeError("expected function")
    }
  }

  $.fn.bind = function(event, data, callback){
    return this.on(event, data, callback)
  }
  $.fn.unbind = function(event, callback){
    return this.off(event, callback)
  }
  $.fn.one = function(event, selector, data, callback){
    return this.on(event, selector, data, callback, 1)
  }

  var returnTrue = function(){return true},
      returnFalse = function(){return false},
      ignoreProperties = /^([A-Z]|returnValue$|layer[XY]$)/,
      eventMethods = {
        preventDefault: 'isDefaultPrevented',
        stopImmediatePropagation: 'isImmediatePropagationStopped',
        stopPropagation: 'isPropagationStopped'
      }

  function compatible(event, source) {
    if (source || !event.isDefaultPrevented) {
      source || (source = event)

      $.each(eventMethods, function(name, predicate) {
        var sourceMethod = source[name]
        event[name] = function(){
          this[predicate] = returnTrue
          return sourceMethod && sourceMethod.apply(source, arguments)
        }
        event[predicate] = returnFalse
      })

      if (source.defaultPrevented !== undefined ? source.defaultPrevented :
          'returnValue' in source ? source.returnValue === false :
          source.getPreventDefault && source.getPreventDefault())
        event.isDefaultPrevented = returnTrue
    }
    return event
  }

  function createProxy(event) {
    var key, proxy = { originalEvent: event }
    for (key in event)
      if (!ignoreProperties.test(key) && event[key] !== undefined) proxy[key] = event[key]

    return compatible(proxy, event)
  }

  $.fn.delegate = function(selector, event, callback){
    return this.on(event, selector, callback)
  }
  $.fn.undelegate = function(selector, event, callback){
    return this.off(event, selector, callback)
  }

  $.fn.live = function(event, callback){
    $(document.body).delegate(this.selector, event, callback)
    return this
  }
  $.fn.die = function(event, callback){
    $(document.body).undelegate(this.selector, event, callback)
    return this
  }

  $.fn.on = function(event, selector, data, callback, one){
    var autoRemove, delegator, $this = this
    if (event && !isString(event)) {
      $.each(event, function(type, fn){
        $this.on(type, selector, data, fn, one)
      })
      return $this
    }

    if (!isString(selector) && !isFunction(callback) && callback !== false)
      callback = data, data = selector, selector = undefined
    if (isFunction(data) || data === false)
      callback = data, data = undefined

    if (callback === false) callback = returnFalse

    return $this.each(function(_, element){
      if (one) autoRemove = function(e){
        remove(element, e.type, callback)
        return callback.apply(this, arguments)
      }

      if (selector) delegator = function(e){
        var evt, match = $(e.target).closest(selector, element).get(0)
        if (match && match !== element) {
          evt = $.extend(createProxy(e), {currentTarget: match, liveFired: element})
          return (autoRemove || callback).apply(match, [evt].concat(slice.call(arguments, 1)))
        }
      }

      add(element, event, callback, data, selector, delegator || autoRemove)
    })
  }
  $.fn.off = function(event, selector, callback){
    var $this = this
    if (event && !isString(event)) {
      $.each(event, function(type, fn){
        $this.off(type, selector, fn)
      })
      return $this
    }

    if (!isString(selector) && !isFunction(callback) && callback !== false)
      callback = selector, selector = undefined

    if (callback === false) callback = returnFalse

    return $this.each(function(){
      remove(this, event, callback, selector)
    })
  }

  $.fn.trigger = function(event, args){
    event = (isString(event) || $.isPlainObject(event)) ? $.Event(event) : compatible(event)
    event._args = args
    return this.each(function(){
      // items in the collection might not be DOM elements
      if('dispatchEvent' in this) this.dispatchEvent(event)
      else $(this).triggerHandler(event, args)
    })
  }

  // triggers event handlers on current element just as if an event occurred,
  // doesn't trigger an actual event, doesn't bubble
  $.fn.triggerHandler = function(event, args){
    var e, result
    this.each(function(i, element){
      e = createProxy(isString(event) ? $.Event(event) : event)
      e._args = args
      e.target = element
      $.each(findHandlers(element, event.type || event), function(i, handler){
        result = handler.proxy(e)
        if (e.isImmediatePropagationStopped()) return false
      })
    })
    return result
  }

  // shortcut methods for `.bind(event, fn)` for each event type
  ;('focusin focusout load resize scroll unload click dblclick '+
  'mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave '+
  'change select keydown keypress keyup error').split(' ').forEach(function(event) {
    $.fn[event] = function(callback) {
      return callback ?
        this.bind(event, callback) :
        this.trigger(event)
    }
  })

  ;['focus', 'blur'].forEach(function(name) {
    $.fn[name] = function(callback) {
      if (callback) this.bind(name, callback)
      else this.each(function(){
        try { this[name]() }
        catch(e) {}
      })
      return this
    }
  })

  $.Event = function(type, props) {
    if (!isString(type)) props = type, type = props.type
    var event = document.createEvent(specialEvents[type] || 'Events'), bubbles = true
    if (props) for (var name in props) (name == 'bubbles') ? (bubbles = !!props[name]) : (event[name] = props[name])
    event.initEvent(type, bubbles, true)
    return compatible(event)
  }

});

define('lib/core/zepto/touch',function(require,exports,module){

  var $ = require('lib/core/zepto/zepto');
//     Zepto.js
//     (c) 2010-2014 Thomas Fuchs
//     Zepto.js may be freely distributed under the MIT license.

  var touch = {},
    touchTimeout, tapTimeout, swipeTimeout, longTapTimeout,
    longTapDelay = 750,
    gesture

  function swipeDirection(x1, x2, y1, y2) {
    return Math.abs(x1 - x2) >=
      Math.abs(y1 - y2) ? (x1 - x2 > 0 ? 'Left' : 'Right') : (y1 - y2 > 0 ? 'Up' : 'Down')
  }

  function longTap() {
    longTapTimeout = null
    if (touch.last) {
      touch.el.trigger('longTap')
      touch = {}
    }
  }

  function cancelLongTap() {
    if (longTapTimeout) clearTimeout(longTapTimeout)
    longTapTimeout = null
  }

  function cancelAll() {
    if (touchTimeout) clearTimeout(touchTimeout)
    if (tapTimeout) clearTimeout(tapTimeout)
    if (swipeTimeout) clearTimeout(swipeTimeout)
    if (longTapTimeout) clearTimeout(longTapTimeout)
    touchTimeout = tapTimeout = swipeTimeout = longTapTimeout = null
    touch = {}
  }

  function isPrimaryTouch(event){
    return (event.pointerType == 'touch' ||
      event.pointerType == event.MSPOINTER_TYPE_TOUCH)
      && event.isPrimary
  }

  function isPointerEventType(e, type){
    return (e.type == 'pointer'+type ||
      e.type.toLowerCase() == 'mspointer'+type)
  }

  $(document).ready(function(){
    var now, delta, deltaX = 0, deltaY = 0, firstTouch, _isPointerType

    if ('MSGesture' in window) {
      gesture = new MSGesture()
      gesture.target = document.body
    }

    $(document)
      .bind('MSGestureEnd', function(e){
        var swipeDirectionFromVelocity =
          e.velocityX > 1 ? 'Right' : e.velocityX < -1 ? 'Left' : e.velocityY > 1 ? 'Down' : e.velocityY < -1 ? 'Up' : null;
        if (swipeDirectionFromVelocity) {
          touch.el.trigger('swipe')
          touch.el.trigger('swipe'+ swipeDirectionFromVelocity)
        }
      })
      .on('touchstart MSPointerDown pointerdown', function(e){
        deltaX = deltaY = 0
        if((_isPointerType = isPointerEventType(e, 'down')) &&
          !isPrimaryTouch(e)) return
        firstTouch = _isPointerType ? e : e.touches[0]
        if (e.touches && e.touches.length === 1 && touch.x2) {
          // Clear out touch movement data if we have it sticking around
          // This can occur if touchcancel doesn't fire due to preventDefault, etc.
          touch.x2 = undefined
          touch.y2 = undefined
        }
        now = Date.now()
        delta = now - (touch.last || now)
        touch.el = $('tagName' in firstTouch.target ?
          firstTouch.target : firstTouch.target.parentNode)
        touchTimeout && clearTimeout(touchTimeout)
        touch.x1 = firstTouch.pageX
        touch.y1 = firstTouch.pageY
        if (delta > 0 && delta <= 250) touch.isDoubleTap = true
        touch.last = now
        longTapTimeout = setTimeout(longTap, longTapDelay)
        // adds the current touch contact for IE gesture recognition
        if (gesture && _isPointerType) gesture.addPointer(e.pointerId);
      })
      .on('touchmove MSPointerMove pointermove', function(e){
        if((_isPointerType = isPointerEventType(e, 'move')) &&
          !isPrimaryTouch(e)) return
        firstTouch = _isPointerType ? e : e.touches[0]
        cancelLongTap()
        touch.x2 = firstTouch.pageX
        touch.y2 = firstTouch.pageY

        deltaX += Math.abs(touch.x1 - touch.x2)
        deltaY += Math.abs(touch.y1 - touch.y2)
      })
      .on('touchend MSPointerUp pointerup', function(e){
        if((_isPointerType = isPointerEventType(e, 'up')) &&
          !isPrimaryTouch(e)) return
        cancelLongTap()

        // swipe
        if ((touch.x2 && Math.abs(touch.x1 - touch.x2) > 30) ||
            (touch.y2 && Math.abs(touch.y1 - touch.y2) > 30))

          swipeTimeout = setTimeout(function() {
            touch.el.trigger('swipe')
            touch.el.trigger('swipe' + (swipeDirection(touch.x1, touch.x2, touch.y1, touch.y2)))
            touch = {}
          }, 0)

        // normal tap
        else if ('last' in touch)
          // don't fire tap when delta position changed by more than 30 pixels,
          // for instance when moving to a point and back to origin
          if (deltaX < 30 && deltaY < 30) {
            // delay by one tick so we can cancel the 'tap' event if 'scroll' fires
            // ('tap' fires before 'scroll')
            tapTimeout = setTimeout(function() {

              // trigger universal 'tap' with the option to cancelTouch()
              // (cancelTouch cancels processing of single vs double taps for faster 'tap' response)
              var event = $.Event('tap')
              event.cancelTouch = cancelAll
              touch.el.trigger(event)

              // trigger double tap immediately
              if (touch.isDoubleTap) {
                if (touch.el) touch.el.trigger('doubleTap')
                touch = {}
              }

              // trigger single tap after 250ms of inactivity
              else {
                touchTimeout = setTimeout(function(){
                  touchTimeout = null
                  if (touch.el) touch.el.trigger('singleTap')
                  touch = {}
                }, 250)
              }
            }, 0)
          } else {
            touch = {}
          }
          deltaX = deltaY = 0

      })
      // when the browser window loses focus,
      // for example when a modal dialog is shown,
      // cancel all ongoing events
      .on('touchcancel MSPointerCancel pointercancel', cancelAll)

    // scrolling the window indicates intention of the user
    // to scroll, not tap or swipe, so cancel all ongoing events
    $(window).on('scroll', cancelAll)
  })

  ;['swipe', 'swipeLeft', 'swipeRight', 'swipeUp', 'swipeDown',
    'doubleTap', 'tap', 'singleTap', 'longTap'].forEach(function(eventName){
    $.fn[eventName] = function(callback){ return this.on(eventName, callback) }
  })

});


define('lib/core/zepto/ajax',function(require,exports,module){

  var $ = require('lib/core/zepto/zepto');

//     Zepto.js
//     (c) 2010-2014 Thomas Fuchs
//     Zepto.js may be freely distributed under the MIT license.

  var jsonpID = 0,
      document = window.document,
      key,
      name,
      rscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
      scriptTypeRE = /^(?:text|application)\/javascript/i,
      xmlTypeRE = /^(?:text|application)\/xml/i,
      jsonType = 'application/json',
      htmlType = 'text/html',
      blankRE = /^\s*$/

  // trigger a custom event and return false if it was cancelled
  function triggerAndReturn(context, eventName, data) {
    var event = $.Event(eventName)
    $(context).trigger(event, data)
    return !event.isDefaultPrevented()
  }

  // trigger an Ajax "global" event
  function triggerGlobal(settings, context, eventName, data) {
    if (settings.global) return triggerAndReturn(context || document, eventName, data)
  }

  // Number of active Ajax requests
  $.active = 0

  function ajaxStart(settings) {
    if (settings.global && $.active++ === 0) triggerGlobal(settings, null, 'ajaxStart')
  }
  function ajaxStop(settings) {
    if (settings.global && !(--$.active)) triggerGlobal(settings, null, 'ajaxStop')
  }

  // triggers an extra global event "ajaxBeforeSend" that's like "ajaxSend" but cancelable
  function ajaxBeforeSend(xhr, settings) {
    var context = settings.context
    if (settings.beforeSend.call(context, xhr, settings) === false ||
        triggerGlobal(settings, context, 'ajaxBeforeSend', [xhr, settings]) === false)
      return false

    triggerGlobal(settings, context, 'ajaxSend', [xhr, settings])
  }
  function ajaxSuccess(data, xhr, settings, deferred) {
    var context = settings.context, status = 'success'
    settings.success.call(context, data, status, xhr)
    if (deferred) deferred.resolveWith(context, [data, status, xhr])
    triggerGlobal(settings, context, 'ajaxSuccess', [xhr, settings, data])
    ajaxComplete(status, xhr, settings)
  }
  // type: "timeout", "error", "abort", "parsererror"
  function ajaxError(error, type, xhr, settings, deferred) {
    var context = settings.context
    settings.error.call(context, xhr, type, error)
    if (deferred) deferred.rejectWith(context, [xhr, type, error])
    triggerGlobal(settings, context, 'ajaxError', [xhr, settings, error || type])
    ajaxComplete(type, xhr, settings)
  }
  // status: "success", "notmodified", "error", "timeout", "abort", "parsererror"
  function ajaxComplete(status, xhr, settings) {
    var context = settings.context
    settings.complete.call(context, xhr, status)
    triggerGlobal(settings, context, 'ajaxComplete', [xhr, settings])
    ajaxStop(settings)
  }

  // Empty function, used as default callback
  function empty() {}

  $.ajaxJSONP = function(options, deferred){
    if (!('type' in options)) return $.ajax(options)

    var _callbackName = options.jsonpCallback,
      callbackName = ($.isFunction(_callbackName) ?
        _callbackName() : _callbackName) || ('jsonp' + (++jsonpID)),
      script = document.createElement('script'),
      originalCallback = window[callbackName],
      responseData,
      abort = function(errorType) {
        $(script).triggerHandler('error', errorType || 'abort')
      },
      xhr = { abort: abort }, abortTimeout

    if (deferred) deferred.promise(xhr)

    $(script).on('load error', function(e, errorType){
      clearTimeout(abortTimeout)
      $(script).off().remove()

      if (e.type == 'error' || !responseData) {
        ajaxError(null, errorType || 'error', xhr, options, deferred)
      } else {
        ajaxSuccess(responseData[0], xhr, options, deferred)
      }

      window[callbackName] = originalCallback
      if (responseData && $.isFunction(originalCallback))
        originalCallback(responseData[0])

      originalCallback = responseData = undefined
    })

    if (ajaxBeforeSend(xhr, options) === false) {
      abort('abort')
      return xhr
    }

    window[callbackName] = function(){
      responseData = arguments
    }

    script.src = options.url.replace(/\?(.+)=\?/, '?$1=' + callbackName)
    document.head.appendChild(script)

    if (options.timeout > 0) abortTimeout = setTimeout(function(){
      abort('timeout')
    }, options.timeout)

    return xhr
  }

  $.ajaxSettings = {
    // Default type of request
    type: 'GET',
    // Callback that is executed before request
    beforeSend: empty,
    // Callback that is executed if the request succeeds
    success: empty,
    // Callback that is executed the the server drops error
    error: empty,
    // Callback that is executed on request complete (both: error and success)
    complete: empty,
    // The context for the callbacks
    context: null,
    // Whether to trigger "global" Ajax events
    global: true,
    // Transport
    xhr: function () {
      return new window.XMLHttpRequest()
    },
    // MIME types mapping
    // IIS returns Javascript as "application/x-javascript"
    accepts: {
      script: 'text/javascript, application/javascript, application/x-javascript',
      json:   jsonType,
      xml:    'application/xml, text/xml',
      html:   htmlType,
      text:   'text/plain'
    },
    // Whether the request is to another domain
    crossDomain: false,
    // Default timeout
    timeout: 0,
    // Whether data should be serialized to string
    processData: true,
    // Whether the browser should be allowed to cache GET responses
    cache: true
  }

  function mimeToDataType(mime) {
    if (mime) mime = mime.split(';', 2)[0]
    return mime && ( mime == htmlType ? 'html' :
      mime == jsonType ? 'json' :
      scriptTypeRE.test(mime) ? 'script' :
      xmlTypeRE.test(mime) && 'xml' ) || 'text'
  }

  function appendQuery(url, query) {
    if (query == '') return url
    return (url + '&' + query).replace(/[&?]{1,2}/, '?')
  }

  // serialize payload and append it to the URL for GET requests
  function serializeData(options) {
    if (options.processData && options.data && $.type(options.data) != "string")
      options.data = $.param(options.data, options.traditional)
    if (options.data && (!options.type || options.type.toUpperCase() == 'GET'))
      options.url = appendQuery(options.url, options.data), options.data = undefined
  }

  $.ajax = function(options){
    var settings = $.extend({}, options || {}),
        deferred = $.Deferred && $.Deferred()
    for (key in $.ajaxSettings) if (settings[key] === undefined) settings[key] = $.ajaxSettings[key]

    ajaxStart(settings)

    if (!settings.crossDomain) settings.crossDomain = /^([\w-]+:)?\/\/([^\/]+)/.test(settings.url) &&
      RegExp.$2 != window.location.host

    if (!settings.url) settings.url = window.location.toString()
    serializeData(settings)
    if (settings.cache === false) settings.url = appendQuery(settings.url, '_=' + Date.now())

    var dataType = settings.dataType, hasPlaceholder = /\?.+=\?/.test(settings.url)
    if (dataType == 'jsonp' || hasPlaceholder) {
      if (!hasPlaceholder)
        settings.url = appendQuery(settings.url,
          settings.jsonp ? (settings.jsonp + '=?') : settings.jsonp === false ? '' : 'callback=?')
      return $.ajaxJSONP(settings, deferred)
    }

    var mime = settings.accepts[dataType],
        headers = { },
        setHeader = function(name, value) { headers[name.toLowerCase()] = [name, value] },
        protocol = /^([\w-]+:)\/\//.test(settings.url) ? RegExp.$1 : window.location.protocol,
        xhr = settings.xhr(),
        nativeSetHeader = xhr.setRequestHeader,
        abortTimeout

    if (deferred) deferred.promise(xhr)

    if (!settings.crossDomain) setHeader('X-Requested-With', 'XMLHttpRequest')
    setHeader('Accept', mime || '*/*')
    if (mime = settings.mimeType || mime) {
      if (mime.indexOf(',') > -1) mime = mime.split(',', 2)[0]
      xhr.overrideMimeType && xhr.overrideMimeType(mime)
    }
    if (settings.contentType || (settings.contentType !== false && settings.data && settings.type.toUpperCase() != 'GET'))
      setHeader('Content-Type', settings.contentType || 'application/x-www-form-urlencoded')

    if (settings.headers) for (name in settings.headers) setHeader(name, settings.headers[name])
    xhr.setRequestHeader = setHeader

    xhr.onreadystatechange = function(){
      if (xhr.readyState == 4) {
        xhr.onreadystatechange = empty
        clearTimeout(abortTimeout)
        var result, error = false
        if ((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304 || (xhr.status == 0 && protocol == 'file:')) {
          dataType = dataType || mimeToDataType(settings.mimeType || xhr.getResponseHeader('content-type'))
          result = xhr.responseText

          try {
            // http://perfectionkills.com/global-eval-what-are-the-options/
            if (dataType == 'script')    (1,eval)(result)
            else if (dataType == 'xml')  result = xhr.responseXML
            else if (dataType == 'json') result = blankRE.test(result) ? null : $.parseJSON(result)
          } catch (e) { error = e }

          if (error) ajaxError(error, 'parsererror', xhr, settings, deferred)
          else ajaxSuccess(result, xhr, settings, deferred)
        } else {
          ajaxError(xhr.statusText || null, xhr.status ? 'error' : 'abort', xhr, settings, deferred)
        }
      }
    }

    if (ajaxBeforeSend(xhr, settings) === false) {
      xhr.abort()
      ajaxError(null, 'abort', xhr, settings, deferred)
      return xhr
    }

    if (settings.xhrFields) for (name in settings.xhrFields) xhr[name] = settings.xhrFields[name]

    var async = 'async' in settings ? settings.async : true
    xhr.open(settings.type, settings.url, async, settings.username, settings.password)

    for (name in headers) nativeSetHeader.apply(xhr, headers[name])

    if (settings.timeout > 0) abortTimeout = setTimeout(function(){
        xhr.onreadystatechange = empty
        xhr.abort()
        ajaxError(null, 'timeout', xhr, settings, deferred)
      }, settings.timeout)

    // avoid sending empty string (#319)
    xhr.send(settings.data ? settings.data : null)
    return xhr
  }

  // handle optional data/success arguments
  function parseArguments(url, data, success, dataType) {
    if ($.isFunction(data)) dataType = success, success = data, data = undefined
    if (!$.isFunction(success)) dataType = success, success = undefined
    return {
      url: url
    , data: data
    , success: success
    , dataType: dataType
    }
  }

  $.get = function(/* url, data, success, dataType */){
    return $.ajax(parseArguments.apply(null, arguments))
  }

  $.post = function(/* url, data, success, dataType */){
    var options = parseArguments.apply(null, arguments)
    options.type = 'POST'
    return $.ajax(options)
  }

  $.getJSON = function(/* url, data, success */){
    var options = parseArguments.apply(null, arguments)
    options.dataType = 'json'
    return $.ajax(options)
  }

  $.fn.load = function(url, data, success){
    if (!this.length) return this
    var self = this, parts = url.split(/\s/), selector,
        options = parseArguments(url, data, success),
        callback = options.success
    if (parts.length > 1) options.url = parts[0], selector = parts[1]
    options.success = function(response){
      self.html(selector ?
        $('<div>').html(response.replace(rscript, "")).find(selector)
        : response)
      callback && callback.apply(self, arguments)
    }
    $.ajax(options)
    return this
  }

  var escape = encodeURIComponent

  function serialize(params, obj, traditional, scope){
    var type, array = $.isArray(obj), hash = $.isPlainObject(obj)
    $.each(obj, function(key, value) {
      type = $.type(value)
      if (scope) key = traditional ? scope :
        scope + '[' + (hash || type == 'object' || type == 'array' ? key : '') + ']'
      // handle data in serializeArray() format
      if (!scope && array) params.add(value.name, value.value)
      // recurse into nested objects
      else if (type == "array" || (!traditional && type == "object"))
        serialize(params, value, traditional, key)
      else params.add(key, value)
    })
  }

  $.param = function(obj, traditional){
    var params = []
    params.add = function(k, v){ this.push(escape(k) + '=' + escape(v)) }
    serialize(params, obj, traditional)
    return params.join('&').replace(/%20/g, '+')
  }

});

/**
 * @fileoverview zepto 函数扩充插件 
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/core/extra/zepto/zepto',function(require,exports,module){

	var $ = require('lib/core/zepto/zepto');

	var console = window.console;

	//ie7 console.log是一个对象
	var enableLog = console && typeof console.log === 'function';

	$.extend($, {
		noop : function(){},
		log : function(){
			if(enableLog){
				console.log.apply(console, arguments);
			}
		},
		hyphenate : function(str){
			return str.replace(/[A-Z]/g, function($0){
				return '-' + $0.toLowerCase();
			});
		}
	});

	$.extend($.fn, {
		//判断事件是否发生在元素内部(包括元素本身)
		occurInside : function(event){
			if(this.length && event && event.target){
				return this[0] === event.target || this.has(event.target).length;
			}
		},
		//是否存在属性
		hasAttr : function(name){
			return this[0] && this[0].hasAttribute(name);
		},
		reflow : function(){
			var reflow = this.size() && this.get(0).clientLeft;
			return this;
		}
	});

});




/**
 * @fileoverview zepto插件 - 提供免前缀设置CSS3功能 
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/core/extra/zepto/prefixfree',function(require,exports,module){

	var $ = require('lib/core/zepto/zepto');
	require('lib/core/extra/zepto/zepto');

	var PrefixFree;

	var camelCase = $.camelCase;

	var hyphenate = $.hyphenate;

	/**
	 * PrefixFree 1.0.4
	 * @author Lea Verou
	 * @editor liangdong2@staff.sina.com.cn
	 * MIT license
	 */
	(function(root, undefined){

		if(!window.getComputedStyle) {
			return;
		}

		var getComputedStyle = window.getComputedStyle;

		var self = {
			prefixProperty: function(property, bCamelCase) {
				var prefixed = self.prefix + property;
				return bCamelCase ? camelCase(prefixed) : prefixed;
			}
		};

		PrefixFree = self;

		/**************************************
		 * Properties
		 **************************************/
		(function() {
			var i, property,
				prefixes = {},
				highest = { prefix: '', uses: 0},
				properties = [],
				shorthands = {},
				style = getComputedStyle(document.documentElement, null),
				dummy = document.createElement('div').style;

			// Why are we doing this instead of iterating over properties in a .style object? Cause Webkit won't iterate over those.
			var iterate = function(property) {
				pushUnique(properties, property);

				if(property.indexOf('-') > -1) {
					var parts = property.split('-');

					if(property.charAt(0) === '-') {
						var prefix = parts[1],
							uses = ++prefixes[prefix] || 1;

						prefixes[prefix] = uses;

						if(highest.uses < uses) {
							highest = {prefix: prefix, uses: uses};
						}

						// This helps determining shorthands
						while(parts.length > 3) {
							parts.pop();

							var shorthand = parts.join('-'),
								shorthandDOM = camelCase(shorthand);

							if(shorthandDOM in dummy) {
								pushUnique(properties, shorthand);
							}
						}
					}
				}
			};

			// Some browsers have numerical indices for the properties, some don't
			if(style.length > 0) {
				for(i = 0; i < style.length; i++) {
					iterate(style[i]);
				}
			}
			else {
				for(property in style) {
					iterate(hyphenate(property));
				}
			}

			self.prefix = '-' + highest.prefix + '-';
			self.Prefix = camelCase(self.prefix);

			properties.sort();

			self.properties = [];

			// Get properties ONLY supported with a prefix
			for(i=0; i<properties.length; i++){
				property = properties[i];

				if(property.charAt(0) !== '-') {
					break; // it's sorted, so once we get to the first unprefixed property, we're done
				}

				if(property.indexOf(self.prefix) === 0) { // we might have multiple prefixes, like Opera
					var unprefixed = property.slice(self.prefix.length);

					if(!(camelCase(unprefixed) in dummy)) {
						self.properties.push(unprefixed);
					}
				}
			}

			// IE fix
			if(self.Prefix == 'Ms' &&
				!('transform' in dummy) &&
				!('MsTransform' in dummy) &&
				('msTransform' in dummy)
			){
				self.properties.push('transform', 'transform-origin');
			}

			self.properties.sort();
		})();

		// Add class for current prefix
		root.className += ' ' + self.prefix;

		/**************************************
		 * Utilities
		 **************************************/

		function pushUnique(arr, val) {
			if(arr.indexOf(val) === -1) {
				arr.push(val);
			}
		}

	})(document.documentElement);

	(function(){

		if(!PrefixFree){return;}

		var self = PrefixFree;

		$.cssProps = $.cssProps || {};

		var i, property, camelCased, prefix;
		for(i = 0; i < self.properties.length; i++) {
			property = self.properties[i];
			camelCased = camelCase(property);
			prefix = self.prefixProperty(property);
			$.cssProps[camelCased] = prefix;
		}

		var _css = $.fn.css;

		var formatValue = function(value){
			if(!value){return value;}
			value = value.replace(/transform/gi, $.cssProps['transform']);
			return value;
		};

		$.fn.css = function(property, value){
			var key, prefixKey, camelCased;
			if(typeof property === 'string'){
				camelCased = camelCase(property);
				if($.cssProps[camelCased]){
					property = $.cssProps[camelCased];
					value = formatValue(value);
				}
			}else{
				for(key in property){
					camelCased = camelCase(key);
					if($.cssProps[camelCased]){
						prefixKey = $.cssProps[camelCased];
						property[prefixKey] = formatValue(property[key]);
						delete property[key];
					}
				}
			}

			if(arguments.length < 2){
				return _css.apply(this, [property]);
			}else{
				return _css.apply(this, [property, value]);
			}
		};

		$.getPrefix = function(){
			return PrefixFree.prefix;
		};

	})();


});


/**
 * @fileoverview zepto transform属性获取与设置 
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 * @param {String} property 要设置的 transform 属性
 * @param {Object} property transform 键值对
 * @param {String} value 要设置的 transform 值
 * @returns transform属性值， transform字符串，或者undefined
 * @example
	$('div').transform('translateX', '20px');
	$('div').transform({
		'translateX' : '20px'
	});
	$('div').transform();	//'translateX(20px)'
	$('div').transform('translateX');	//'20px'
 */
define('lib/core/extra/zepto/transform',function(require,exports,module){

	var $ = require('lib/core/zepto/zepto');

	$.fn.transform = function(property, value){
		var obj = {};
		var transform = $(this).css('transform') || '';
		transform = transform === 'none' ? '' : transform;

		transform = transform.replace(/,\s+/gi, ',');

		$.each(transform.split(/\s+/gi), function(index, str){
			if(!str){return;}
			var name = str.match(/\w+/)[0];
			var val = str.replace(name, '').replace(/[\(\)]/gi,'');
			val = $.trim(val);
			obj[name] = val;
		});

		if(!property){
			return obj;
		}

		if(typeof property === 'string'){
			if($.type(value) === 'undefined'){
				return obj[property] || 0;
			}else{
				obj[property] = value;
			}
		}else{
			$.extend(obj, property);
		}

		transform = [];
		$.each(obj, function(key, val){
			var str = key + '(' + val + ')';
			transform.push(str);
		});

		if(transform.length){
			transform = transform.join(' ');
		}else{
			transform = '';
		}

		return $(this).css('transform', transform);
	};

});




/**
 * @fileoverview 封装使用transition的动画
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('lib/core/extra/zepto/transit',function(require,exports,module){

	var $ = require('lib/core/zepto/zepto');

	//Zepto.js
	//(c) 2010-2014 Thomas Fuchs
	//Zepto.js may be freely distributed under the MIT license.

	var prefix = '', eventPrefix, endEventName, endAnimationName,
		vendors = { Webkit: 'webkit', Moz: '', O: 'o' },
		document = window.document, testEl = document.createElement('div'),
		supportedTransforms = /^((translate|rotate|scale)(X|Y|Z|3d)?|matrix(3d)?|perspective|skew(X|Y)?)$/i,
		transform,
		transitionProperty, transitionDuration, transitionTiming, transitionDelay,
		animationName, animationDuration, animationTiming, animationDelay,
		cssReset = {};

	function dasherize(str) { return str.replace(/([a-z])([A-Z])/, '$1-$2').toLowerCase(); }
	function normalizeEvent(name) { return eventPrefix ? eventPrefix + name : name.toLowerCase(); }

	$.each(vendors, function(vendor, event){
		if (testEl.style[vendor + 'TransitionProperty'] !== undefined) {
			prefix = '-' + vendor.toLowerCase() + '-';
			eventPrefix = event;
			return false;
		}
	});

	transform = 'transform';
	cssReset[transitionProperty = 'transition-property'] =
	cssReset[transitionDuration = 'transition-duration'] =
	cssReset[transitionDelay    = 'transition-delay'] =
	cssReset[transitionTiming   = 'transition-timing-function'] =
	cssReset[animationName      = 'animation-name'] =
	cssReset[animationDuration  = 'animation-duration'] =
	cssReset[animationDelay     = 'animation-delay'] =
	cssReset[animationTiming    = 'animation-timing-function'] = '';

	$.fx = {
		off: (eventPrefix === undefined && testEl.style.transitionProperty === undefined),
		speeds: { _default: 400, fast: 200, slow: 600 },
		cssPrefix: prefix,
		transitionEnd: normalizeEvent('TransitionEnd'),
		animationEnd: normalizeEvent('AnimationEnd')
	};

	$.fn.transit = function(properties, duration, ease, callback, delay){
		if ($.isFunction(duration)){
			callback = duration;
			ease = undefined;
			duration = undefined;
		}

		if ($.isFunction(ease)){
			callback = ease;
			ease = undefined;
		}

		if ($.isPlainObject(duration)){
			ease = duration.easing;
			callback = duration.complete;
			delay = duration.delay;
			duration = duration.duration;
		}

		if (duration){
			duration = (typeof duration == 'number' ? duration :
				($.fx.speeds[duration] || $.fx.speeds._default)) / 1000;
		}
		if (delay){
			delay = parseFloat(delay) / 1000;
		}

		return this.anim(properties, duration, ease, callback, delay);
	};

	$.fn.anim = function(properties, duration, ease, callback, delay){
		var key, cssValues = {}, cssProperties, transforms = '',
			that = this, wrappedCallback, endEvent = $.fx.transitionEnd,
			fired = false;

		if (duration === undefined) duration = $.fx.speeds._default / 1000;
		if (delay === undefined) delay = 0;
		if ($.fx.off) duration = 0;

		if (typeof properties == 'string') {
			// keyframe animation
			cssValues[animationName] = properties;
			cssValues[animationDuration] = duration + 's';
			cssValues[animationDelay] = delay + 's';
			cssValues[animationTiming] = (ease || 'linear');
			endEvent = $.fx.animationEnd;
		} else {
			cssProperties = [];
			// CSS transitions
			for (key in properties){
				if (supportedTransforms.test(key)){
					transforms += key + '(' + properties[key] + ') ';
				}else{
					cssValues[key] = properties[key];
					cssProperties.push(dasherize(key));
				}
			}

			if (transforms){
				cssValues[transform] = transforms;
				cssProperties.push(transform);
			}

			if (duration > 0 && typeof properties === 'object') {
				cssValues[transitionProperty] = '*';
				cssValues[transitionDuration] = duration + 's';
				cssValues[transitionDelay] = delay + 's';
				cssValues[transitionTiming] = (ease || 'linear');
			}
		}

		wrappedCallback = function(event){
			if (typeof event !== 'undefined') {
				// makes sure the event didn't bubble from "below"
				if(event.target !== event.currentTarget){return;}
				$(event.target).unbind(endEvent, wrappedCallback);
			} else{
				// triggered by setTimeout
				$(this).unbind(endEvent, wrappedCallback);
			}
			
			fired = true;
			$(this).css(cssReset);
			if(callback){
				callback.call(this);
			}
		};

		if (duration > 0){
			this.bind(endEvent, wrappedCallback);
			// transitionEnd is not always firing on older Android phones
			// so make sure it gets fired
			setTimeout(function(){
				if (fired) {return;}
				wrappedCallback.call(that);
			}, (duration * 1000) + 25);
		}

		// trigger page reflow so new elements can animate
		var reflow = this.size() && this.get(0).clientLeft;

		this.css(cssValues);

		if (duration <= 0) setTimeout(function() {
			that.each(function(){
				wrappedCallback.call(this);
			});
		}, 0);

		return this;
	};

	testEl = null;

});


/**
 * @fileoverview 类
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('lib/more/class',function(require,exports,module){

  //来自arale js

  // Class
  // -----------------
  // Thanks to:
  //  - http://mootools.net/docs/core/Class/Class
  //  - http://ejohn.org/blog/simple-javascript-inheritance/
  //  - https://github.com/ded/klass
  //  - http://documentcloud.github.com/backbone/#Model-extend
  //  - https://github.com/joyent/node/blob/master/lib/util.js
  //  - https://github.com/kissyteam/kissy/blob/master/src/seed/src/kissy.js


  // The base Class implementation.
  function Class(o) {
    // Convert existed function to Class.
    if (!(this instanceof Class) && isFunction(o)) {
      return classify(o)
    }
  }

  module.exports = Class


  // Create a new Class.
  //
  //  var SuperPig = Class.create({
  //    Extends: Animal,
  //    Implements: Flyable,
  //    initialize: function() {
  //      SuperPig.superclass.initialize.apply(this, arguments)
  //    },
  //    Statics: {
  //      COLOR: 'red'
  //    }
  // })
  //
  Class.create = function(parent, properties) {
    if (!isFunction(parent)) {
      properties = parent
      parent = null
    }

    properties || (properties = {})
    parent || (parent = properties.Extends || Class)
    properties.Extends = parent

    // The created class constructor
    function SubClass() {
      // Call the parent constructor.
      parent.apply(this, arguments)

      // Only call initialize in self constructor.
      if (this.constructor === SubClass && this.initialize) {
        this.initialize.apply(this, arguments)
      }
    }

    // Inherit class (static) properties from parent.
    if (parent !== Class) {
      mix(SubClass, parent, parent.StaticsWhiteList)
    }

    // Add instance properties to the subclass.
    implement.call(SubClass, properties)

    // Make subclass extendable.
    return classify(SubClass)
  }


  function implement(properties) {
    var key, value

    for (key in properties) {
      value = properties[key]

      if (Class.Mutators.hasOwnProperty(key)) {
        Class.Mutators[key].call(this, value)
      } else {
        this.prototype[key] = value
      }
    }
  }


  // Create a sub Class based on `Class`.
  Class.extend = function(properties) {
    properties || (properties = {})
    properties.Extends = this

    return Class.create(properties)
  }


  function classify(cls) {
    cls.extend = Class.extend
    cls.implement = implement
    return cls
  }


  // Mutators define special properties.
  Class.Mutators = {

    'Extends': function(parent) {
      var existed = this.prototype
      var proto = createProto(parent.prototype)

      // Keep existed properties.
      mix(proto, existed)

      // Enforce the constructor to be what we expect.
      proto.constructor = this

      // Set the prototype chain to inherit from `parent`.
      this.prototype = proto

      // Set a convenience property in case the parent's prototype is
      // needed later.
      this.superclass = parent.prototype

      // Add module meta information in sea.js environment.
      addMeta(proto)
    },

    'Implements': function(items) {
      isArray(items) || (items = [items])
      var proto = this.prototype, item

      while (item = items.shift()) {
        mix(proto, item.prototype || item)
      }
    },

    'Statics': function(staticProperties) {
      mix(this, staticProperties)
    }
  }


  // Shared empty constructor function to aid in prototype-chain creation.
  function Ctor() {
  }

  // See: http://jsperf.com/object-create-vs-new-ctor
  var createProto = Object.__proto__ ?
      function(proto) {
        return { __proto__: proto }
      } :
      function(proto) {
        Ctor.prototype = proto
        return new Ctor()
      }


  // Helpers
  // ------------

  function mix(r, s, wl) {
    // Copy "all" properties including inherited ones.
    for (var p in s) {
      if (s.hasOwnProperty(p)) {
        if (wl && indexOf(wl, p) === -1) continue

        // 在 iPhone 1 代等设备的 Safari 中，prototype 也会被枚举出来，需排除
        if (p !== 'prototype') {
          r[p] = s[p]
        }
      }
    }
  }


  var toString = Object.prototype.toString
  var isArray = Array.isArray

  if (!isArray) {
    isArray = function(val) {
      return toString.call(val) === '[object Array]'
    }
  }

  var isFunction = function(val) {
    return toString.call(val) === '[object Function]'
  }

  var indexOf = Array.prototype.indexOf ?
      function(arr, item) {
        return arr.indexOf(item)
      } :
      function(arr, item) {
        for (var i = 0, len = arr.length; i < len; i++) {
          if (arr[i] === item) {
            return i
          }
        }
        return -1
      }


  var getCompilingModule = module.constructor._getCompilingModule

  function addMeta(proto) {
    if (!getCompilingModule) return

    var compilingModule = getCompilingModule()
    if (!compilingModule) return

    var filename = compilingModule.uri.split(/[\/\\]/).pop()

    if (Object.defineProperties) {
      Object.defineProperties(proto, {
        __module: { value: compilingModule },
        __filename: { value: filename }
      })
    }
    else {
      proto.__module = compilingModule
      proto.__filename = filename
    }
  }

});

/**
 * @fileoverview 事件
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('lib/more/events',function(require,exports,module){

  //来自arale js

  // Events
  // -----------------
  // Thanks to:
  //  - https://github.com/documentcloud/backbone/blob/master/backbone.js
  //  - https://github.com/joyent/node/blob/master/lib/events.js


  // Regular expression used to split event strings
  var eventSplitter = /\s+/


  // A module that can be mixed in to *any object* in order to provide it
  // with custom events. You may bind with `on` or remove with `off` callback
  // functions to an event; `trigger`-ing an event fires all callbacks in
  // succession.
  //
  //     var object = new Events();
  //     object.on('expand', function(){ alert('expanded'); });
  //     object.trigger('expand');
  //
  function Events() {
  }


  // Bind one or more space separated events, `events`, to a `callback`
  // function. Passing `"all"` will bind the callback to all events fired.
  Events.prototype.on = function(events, callback, context) {
    var cache, event, list
    if (!callback) return this

    cache = this.__events || (this.__events = {})
    events = events.split(eventSplitter)

    while (event = events.shift()) {
      list = cache[event] || (cache[event] = [])
      list.push(callback, context)
    }

    return this
  }


  // Remove one or many callbacks. If `context` is null, removes all callbacks
  // with that function. If `callback` is null, removes all callbacks for the
  // event. If `events` is null, removes all bound callbacks for all events.
  Events.prototype.off = function(events, callback, context) {
    var cache, event, list, i

    // No events, or removing *all* events.
    if (!(cache = this.__events)) return this
    if (!(events || callback || context)) {
      delete this.__events
      return this
    }

    events = events ? events.split(eventSplitter) : keys(cache)

    // Loop through the callback list, splicing where appropriate.
    while (event = events.shift()) {
      list = cache[event]
      if (!list) continue

      if (!(callback || context)) {
        delete cache[event]
        continue
      }

      for (i = list.length - 2; i >= 0; i -= 2) {
        if (!(callback && list[i] !== callback ||
            context && list[i + 1] !== context)) {
          list.splice(i, 2)
        }
      }
    }

    return this
  }


  // Trigger one or many events, firing all bound callbacks. Callbacks are
  // passed the same arguments as `trigger` is, apart from the event name
  // (unless you're listening on `"all"`, which will cause your callback to
  // receive the true name of the event as the first argument).
  Events.prototype.trigger = function(events) {
    var cache, event, all, list, i, len, rest = [], args
    if (!(cache = this.__events)) return this

    events = events.split(eventSplitter)

    // Fill up `rest` with the callback arguments.  Since we're only copying
    // the tail of `arguments`, a loop is much faster than Array#slice.
    for (i = 1, len = arguments.length; i < len; i++) {
      rest[i - 1] = arguments[i]
    }

    // For each event, walk through the list of callbacks twice, first to
    // trigger the event, then to trigger any `"all"` callbacks.
    while (event = events.shift()) {
      // Copy callback lists to prevent modification.
      if (all = cache.all) all = all.slice()
      if (list = cache[event]) list = list.slice()

      // Execute event callbacks.
      if (list) {
        for (i = 0, len = list.length; i < len; i += 2) {
          list[i].apply(list[i + 1] || this, rest)
        }
      }

      // Execute "all" callbacks.
      if (all) {
        args = [event].concat(rest)
        for (i = 0, len = all.length; i < len; i += 2) {
          all[i].apply(all[i + 1] || this, args)
        }
      }
    }

    return this
  }


  // Mix `Events` to object instance or Class function.
  Events.mixTo = function(receiver) {
    receiver = receiver.prototype || receiver
    var proto = Events.prototype

    for (var p in proto) {
      if (proto.hasOwnProperty(p)) {
        receiver[p] = proto[p]
      }
    }
  }


  // Helpers
  // -------

  var keys = Object.keys

  if (!keys) {
    keys = function(o) {
      var result = []

      for (var name in o) {
        if (o.hasOwnProperty(name)) {
          result.push(name)
        }
      }
      return result
    }
  }

  module.exports = Events;

});

/**
 * @fileoverview 获取唯一ID 
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('lib/kit/util/getUniqueKey',function(require,exports,module){

	var time = + new Date(), index = 1;

	//生成一个不重复的随机字符串
	module.exports = function() {
		return ( time + (index++) ).toString(16);
	};

});


/**
 * @fileoverview 公共组件 
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('conf/global',function(require,exports,module){

	require('lib/more/es5-safe');
	require('lib');

	require('lib/mvc/base');
	require('lib/mvc/model');
	require('lib/mvc/view');
	require('lib/mvc/delegate');

	require('lib/more/querystring');

	require('lib/common/htmlRender');
	require('lib/common/listener');
	require('lib/common/jsbridge');

});



/**
 * @fileoverview 按钮类型的UI，带有active状态
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/ui/button',function(require,exports,module){

	var $ = require('lib');
	var $doc = $(document);

	var UI_NAME = 'ui-button';
	var selector = '[' + UI_NAME + ']';

	var uiconf = {};

	$doc.delegate(selector, 'touchstart', function(evt){
		$(evt.currentTarget).addClass('active');
	});

	$doc.delegate(selector, 'touchcancel', function(evt){
		$(evt.currentTarget).removeClass('active');
	});

	$doc.delegate(selector, 'touchend', function(evt){
		$(evt.currentTarget).removeClass('active');
	});

	$doc.delegate(selector, 'touchmove', function(evt){
		$(evt.currentTarget).removeClass('active');
	});

	module.exports = {
		init : function(options){
			$.extend(uiconf, options);
		}
	};

});


/**
 * @fileoverview 链接类型的UI，点击后触发功能
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/ui/link',function(require,exports,module){
	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $bridge = require('mods/bridge/global');
	var $imgbox = require('mods/ui/imgbox');
	var $imgsbox = require('mods/ui/imgsbox');
	var $propQuery = require('lib/kit/util/propQuery');

	var UI_NAME = 'ui-link';
	var selector = '[' + UI_NAME + ']';

	var $doc = $(document);
	var uiconf = {};

	var checkTap = function(el){
		var disabled = el.attr('link-status') === 'disabled';
		if(disabled){return;}

		if($imgbox.isEmptyImgbox(el)){
			return;
		}

		if($imgsbox.isEmptyImgbox(el)){
			return;
		}
		var data = el.attr(UI_NAME);
		data = $propQuery.parse(data);

		if(data.offset){
			data.offset = el.offset();
		}
		if(data.pos){
			data.pos = {};
			var pos = el.get(0).getBoundingClientRect();
			//ios8下 pos对象未能正常解析json字符串 所以遍历属性输出值
			['bottom','height','left','right','top','width'].forEach(function(key){
				data.pos[key] = pos[key];
			});
		}
		//此处新增content字段，从属性中获取其值，是因为内容存在的
		//数据会比较复杂，很有可能造成底层参数解析失败，故单开字段取值

		var content = el.attr('extra-content');
		if(content){
			data.extracontent = content;
		}

		var method = data.method || 'link';
		delete data.method;

		$bridge.request(method, {
			data : data
		});
	};

	$htmlRender.ready(function(){
		$doc.delegate(selector, 'tap', function(evt){
			var el = $(evt.currentTarget);
			var target = $(evt.target);
			var isUILink = true;
			if(
				(!target.hasAttr(UI_NAME) &&
				target.prop('tagName').toLowerCase() === 'a' &&
				target.attr('href') &&
				!target.hasAttr('disabled'))
			){
				isUILink = false;
			}
			if(isUILink){
				checkTap(el);
			}
		});
	});

	module.exports = {
		uiname : UI_NAME,
		selector : selector,
		init : function(options){
			$.extend(uiconf, options);
		}
	};

});


/**
 * @fileoverview 接受客户端下载的图片并展示
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/ui/imgbox',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $channelApp = require('mods/channel/app');
	var $bridge = require('mods/bridge/global');

	var UI_NAME = 'ui-imgbox';
	var selector = '[' + UI_NAME + ']';

	var $doc = $(document);

	var uiconf = {
		styleError : 'error',
		styleLoading : 'loading',
		styleErrorSmall : 'C_downloadsmall',
		styleErrorTooSmall : 'C_downloadsmaller'
	};

	//依据图片元素查找对应图片盒子元素
	var findImgBox = function(imgNode){
		imgNode = $(imgNode);
		var imgBox;
		if(imgNode.hasAttr(UI_NAME)){
			imgBox = imgNode;
		}else{
			imgBox = imgNode.parents(selector);
		}
		return imgBox;
	};

	//依据图片盒子元素查找对应图片元素
	var findImgNode = function(imgBox){
		imgBox = $(imgBox);
		var imgNode;
		if(
			imgBox.hasAttr('data-src') ||
			imgBox.hasAttr('data-bg')
		){
			imgNode = imgBox;
		}else{
			imgNode = imgBox.find('[data-src]');
			if(!imgNode.length){
				imgNode = imgBox.find('[data-bg]');
			}
		}
		return imgNode;
	};

	//获取图片元素的待下载图片地址
	var getDataSrc = function(imgNode){
		imgNode = $(imgNode);
		var data = {};
		if(imgNode.hasAttr('data-src')){
			data.src = imgNode.attr('data-src');
		}else if(imgNode.hasAttr('data-bg')){
			data.src = imgNode.attr('data-bg');
		}

		if(imgNode.hasAttr('data-gif')){
			data.gif = imgNode.attr('data-gif');
		}
		return data;
	};

	//获取图片元素上的当前图片地址
	var getSrc = function(imgNode){
		imgNode = $(imgNode);
		var src = '';
		if(imgNode.hasAttr('data-src')){
			src = imgNode.get(0).getAttribute('src');
		}else if(imgNode.hasAttr('data-bg')){
			src = imgNode.css('background-image');
		}
		return src;
	};

	//判断是否为一个空的图片盒子
	var isEmptyImgbox = function(imgBox){
		var isEmpty = false;
		var imgNode;
		var src = '';
		if(imgBox.hasAttr(UI_NAME)){
			imgNode = findImgNode(imgBox);
			src = getSrc(imgNode);
			src = src || '';
			src = src.trim();
			if(!src || src === 'none' || (/^\[/).test(src)){
				isEmpty = true;
			}else if(
				imgBox.hasClass(uiconf.styleError) ||
				imgBox.hasClass(uiconf.styleLoading)
			){
				isEmpty = true;
			}
		}
		return isEmpty;
	};

	//对于图片下载完成的处理
	var loadImg = function(rs){
		if(!rs || !rs.target){return;}

		//客户端发送的JSON数据需要有3个属性：target, url, local
		//target为图片的ID或者原始地址
		//url为图片的本地地址
		//local 静态图是否下载成功

		var target = rs.target || '';
		var url = rs.url || '';
		var local = rs.local || '';

		target = target.trim();
		url = url.trim();
		$('[data-src="' + target + '"]').add('[data-bg="' + target + '"]').each(function(){
			var imgNode = $(this);
			var imgBox = findImgBox(imgNode);
			imgBox.removeClass(uiconf.styleLoading);
			if((/\.gif$/).test(url)){
				imgNode.css('height', '');
			}
			//此处主要针对gif无论下载成功与否，都必须隐藏loading图
			imgBox.find('.C_gifloading').hide();
			
			if(url){
				imgNode.css('opacity',1);
				if(imgNode.hasAttr('data-src')){
					imgNode.attr('src', url);
				}else{
					imgNode.css('background-image', 'url(' + url + ')');
				}
				if(local){
					imgNode.attr('data-local','1');
				}
			}else{
				// 清空src，添加加载失败样式
				imgNode.attr('src', '');
				//此处添加透明度，是因为部分android手机设置img src＝“” 的时候，即使设置成功，图片并不消失。
				imgNode.css('opacity',0);
				//此处对大图默认图进行优化
                if(!imgBox.closest('[data-pl="pic"]').hasClass('M_picsmall')){
					var height = imgBox.height(),stat;
					imgBox.addClass(uiconf.styleError);
                    stat =  height >= 120 ? 0 : height >= 72 ? 1 : 2;
                    if(stat === 1) {
					    imgBox.addClass(uiconf.styleErrorSmall);
                    }

                    if(stat === 2) {
					    imgBox.addClass(uiconf.styleErrorTooSmall);
                    }
				}else{
					imgBox.addClass(uiconf.styleError);
				}
			}
		});
	};

	var setDomEvents = function(){
		$doc.delegate(selector, 'tap', function(evt){
			var imgBox = $(evt.currentTarget);
			if(imgBox.hasClass(uiconf.styleError)){
				imgBox.removeClass(uiconf.styleError).addClass(uiconf.styleLoading);
				var imgNode = findImgNode(imgBox);
				var datasrc = getDataSrc(imgNode);
				if(imgNode.attr('data-local') === '1' && datasrc.gif){
					$bridge.request('loadImg', {
						data : {
							target : datasrc.src,
							gif : datasrc.gif,
							local : 1
						}
					});
				}else{
					$bridge.request('loadImg', {
						data : {
							target : datasrc.src
						}
					});
				}
			}
		});
	};

	$channelApp.on('img-load', function(rs){
		$htmlRender.ready(function(){
			loadImg(rs);
		});
	});

	module.exports = {
		uiname : UI_NAME,
		selector : selector,
		uiconf : uiconf,
		init : function(options){
			$.extend(uiconf, options);
			$htmlRender.ready(function(){
				setDomEvents();
			});
			// $channelApp.trigger('img-load',{
   //              //target : 'http://l.sinaimg.cn/www/dy/slidenews/4_img/2015_25/704_1657169_663289.jpg/w720q75ndr.jpg',
			// 	target : 'http://n.sinaimg.cn/default/20140801/cfkptvx2674606.jpg',
			// 	url:''
			// });
		},
		isEmptyImgbox : isEmptyImgbox,
		findImgBox : findImgBox,
		findImgNode : findImgNode,
		getDataSrc : getDataSrc,
		getSrc : getSrc
	};

});
 

/**
 * @fileoverview 接受客户端下载的图片并展示
 */

define('mods/ui/imgsbox', function(require, exports, module) {
    var $ = require('lib');
    var $htmlRender = require('lib/common/htmlRender');
    var $channelApp = require('mods/channel/app');
    var $bridge = require('mods/bridge/global');

    var UI_NAME = 'ui-imgsbox';
    var selector = '[' + UI_NAME + ']';

    var $doc = $(document);

    var uiconf = {
        styleError: 'error',
        styleLoading: 'loading',
        styleErrorSmall: 'C_downloadsmall',
        styleErrorTooSmall: 'C_downloadsmaller'
    };

    var imgsCache = {};
    //依据图片元素查找对应图片盒子元素
    var findImgBox = function(imgNode) {
        imgNode = $(imgNode);
        var imgBox;
        if (imgNode.hasAttr(UI_NAME)) {
            imgBox = imgNode;
        } else {
            imgBox = imgNode.parents(selector);
        }
        return imgBox;
    };

    //依据图片盒子元素查找对应图片元素
    var findImgNode = function(imgBox) {
        imgBox = $(imgBox);
        var imgNode;
        if (
            imgBox.hasAttr('datas-src') ||
            imgBox.hasAttr('data-bg')
        ) {
            imgNode = imgBox;
        } else {
            imgNode = imgBox.find('[datas-src]');
            if (!imgNode.length) {
                imgNode = imgBox.find('[data-bg]');
            }
        }
        return imgNode;
    };

    //获取图片元素的待下载图片地址
    var getDataSrc = function(imgNode) {
        imgNode = $(imgNode);
        var data = {};
        if (imgNode.hasAttr('datas-src')) {
            data.src = imgNode.attr('datas-src');
        } else if (imgNode.hasAttr('data-bg')) {
            data.src = imgNode.attr('data-bg');
        }

        if (imgNode.hasAttr('data-gif')) {
            data.gif = imgNode.attr('data-gif');
        }
        return data;
    };

    //获取图片元素上的当前图片地址
    var getSrc = function(imgNode) {
        imgNode = $(imgNode);
        var src = '';
        if (imgNode.hasAttr('datas-src')) {
            src = imgNode.get(0).getAttribute('src');
        } else if (imgNode.hasAttr('data-bg')) {
            src = imgNode.css('background-image');
        }
        return src;
    };

    //判断是否为一个空的图片盒子
    var isEmptyImgbox = function(imgBox) {
        var isEmpty = false;
        var imgNode;
        var src = '';
        if (imgBox.hasAttr(UI_NAME)) {
            imgNode = findImgNode(imgBox);
            src = getSrc(imgNode);
            src = src || '';
            src = src.trim();
            if (!src || src === 'none' || (/^\[/).test(src)) {
                isEmpty = true;
            } else if (
                imgBox.hasClass(uiconf.styleError) ||
                imgBox.hasClass(uiconf.styleLoading)
            ) {
                isEmpty = true;
            }
        }
        return isEmpty;
    };

    //对于图片下载完成的处理

    function loadImg(rs) {
        if (!rs || !rs.target) {
            return;
        }
        var res = loadGroup(rs),
            success = true,
            targets = [],
            $parent, $target,
            url = res.url,
            target = res.target,
            local = res.local;
        imgsCache[escape(target)] = rs;
        $target = $('[datas-src="' + target + '"]');
        $parent = findImgBox($target);

        $parent.find('[datas-src]').each(function() {
            var $target = $(this);
            var res = imgsCache[escape($target.attr('datas-src'))] || {};
            if(!res) {
                success = false;
                return false;
            }
            targets.push({
                target: target,
                $target: $target,
                res :res
            });
        });
        if(success) {
            eachTarget(targets);
        }

        
        function testUrl(targets) {
            var issucc = false,flag = 0;
            targets.forEach(function(item){
                if(item && item.res && item.res.url) {
                    flag++;
                } 
            });
            isSucc = flag == targets.length;
            if(!isSucc) {
                targets.forEach(function(item){
                        // 清空src，添加加载失败样式
                        $imgNode = item.$target; 
                        $imgNode.attr('src', '');
                        //此处添加透明度，是因为部分android手机设置img src＝“” 的时候，即使设置成功，图片并不消失。
                        $imgNode.css('opacity', 0);
                        $parent.addClass(uiconf.styleError);
                        $parent.removeClass(uiconf.styleLoading);
                }); 
            }
            return isSucc;
        }

        function eachTarget(targets) {
            targets.forEach(function(item) {
                var $target = item.$target,
                    target = item.target;
                    var url = item.res && item.res.url || '';
                    if(!testUrl(targets)) {//有失败的图片
                        return false;
                    }
                $target.add('[data-bg="' + target + '"]').each(function() {
                    var imgNode = $(this);
                    var imgBox = findImgBox(imgNode);
                    imgBox.removeClass(uiconf.styleError);
                    imgBox.removeClass(uiconf.styleLoading);
                    if ((/\.gif$/).test(url)) {
                        imgNode.css('height', '');
                    }
                    //此处主要针对gif无论下载成功与否，都必须隐藏loading图
                    imgBox.find('.C_gifloading').hide();
                        imgNode.css('opacity', 1);
                        if (imgNode.hasAttr('datas-src')) {
                            imgNode.attr('src', url);
                        } else {
                            imgNode.css('background-image', 'url(' + url + ')');
                        }
                        if (local) {
                            imgNode.attr('data-local', '1');
                        }
                        
                })
            });

        }
    }

    var loadGroup = function(rs) {
        if (!rs || !rs.target) {
            return {}
        }

        //客户端发送的JSON数据需要有3个属性：target, url, local
        //target为图片的ID或者原始地址
        //url为图片的本地地址
        //local 静态图是否下载成功

        var target = rs.target || '';
        var url = rs.url || '';
        var local = rs.local || '';

        target = target.trim();
        url = url.trim();

        return {
            target: target,
            local: local,
            url: url
        }
    };

    var setDomEvents = function() {
        $doc.delegate(selector, 'tap', function(evt) {
            var imgBox = $(evt.currentTarget);
            if (imgBox.hasClass(uiconf.styleError)) {
                var imgNodes = findImgNode(imgBox);
                imgBox.removeClass(uiconf.styleError).addClass(uiconf.styleLoading);
                imgNodes.each(function(){
                    var imgNode = $(this); 
                    var datasrc = getDataSrc(imgNode);
                    if (imgNode.attr('data-local') === '1' && datasrc.gif) {
                        $bridge.request('loadImg', {
                            data: {
                                target: datasrc.src,
                                gif: datasrc.gif,
                                local: 1
                            }
                        });
                    } else {
                        $bridge.request('loadImg', {
                            data: {
                                target: datasrc.src
                            }
                        });
                    }
                });
            }
        });
    };

    $channelApp.on('img-load', function(rs) {
        $htmlRender.ready(function() {
            loadImg(rs);
        });
    });

    module.exports = {
        uiname: UI_NAME,
        selector: selector,
        uiconf: uiconf,
        init: function(options) {
            $.extend(uiconf, options);
            $htmlRender.ready(function() {
                setDomEvents();
            });
            // $channelApp.trigger('img-load', {
            //     target: 'http://r3.sinaimg.cn/10230/2015/0722/a5/4/07540042/auto.jpg',
            //     //url: 'http://r3.sinaimg.cn/10230/2015/0722/a5/4/07540042/auto.jpg'
            // });
            // $channelApp.trigger('img-load', {
            //     target: 'http://r3.sinaimg.cn/10230/2015/0722/3b/2/42537147/auto.jpg',
            //     url: 'http://r3.sinaimg.cn/10230/2015/0722/3b/2/42537147/auto.jpg'
            // });

            // $channelApp.trigger('img-load', {
            //     target: 'http://r3.sinaimg.cn/10230/2015/0722/4e/b/33545154/auto.jpg',
            //     url: 'http://r3.sinaimg.cn/10230/2015/0722/4e/b/33545154/auto.jpg'
            // });
            // $channelApp.trigger('img-load', {
            //     target: 'http://l.sinaimg.cn/www/dy/slidenews/4_img/2015_30/704_1689992_654225.jpg/w360h270l50t50q75z1ndr.jpg',
            //     url: 'http://l.sinaimg.cn/www/dy/slidenews/4_img/2015_30/704_1689992_654225.jpg/w360h270l50t50q75z1ndr.jpg'
            // });

            // $channelApp.trigger('img-load', {
            //     target: 'http://l.sinaimg.cn/www/dy/slidenews/4_img/2015_30/704_1689993_200823.jpg/w360h270l50t50q75z1ndr.jpg',
            //     url: 'http://l.sinaimg.cn/www/dy/slidenews/4_img/2015_30/704_1689993_200823.jpg/w360h270l50t50q75z1ndr.jpg'
            // });

            // $channelApp.trigger('img-load',{
            //     target : 'http://l.sinaimg.cn/www/dy/slidenews/4_img/2015_30/704_1689988_341424.jpg/w360h540l50t50q75z1ndr.jpg',
            //     url : 'http://l.sinaimg.cn/www/dy/slidenews/4_img/2015_30/704_1689988_341424.jpg/w360h540l50t50q75z1ndr.jpg'
            // });
        },
        isEmptyImgbox: isEmptyImgbox,
        findImgBox: findImgBox,
        findImgNode: findImgNode,
        getDataSrc: getDataSrc,
        getSrc: getSrc
    };

});

/**
 * @fileoverview 幻灯组件
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/ui/slides',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $iScroll = require('vendor/iscroll5');

	var UI_NAME = 'ui-slides';
	var selector = '[' + UI_NAME + ']';

	var uiconf = {};

	var ua = navigator.userAgent.toLowerCase();
    var xiaomi = /(mi 2a)/gi.test(ua);

	var createIScroll = function(box){

		var links = box.find('[ui-link]');

		//scroller高度为0时，会导致 chrome 的 transition 动画无法执行。
		//因此加上最小1像素的高度。
		var scroller = $(box.children().get(0));
		scroller.css('height', scroller.find('.photo').height() + 'px');

		//目前使用的幻灯，marginLeft和marginRight不一致
		//为了能够让幻灯运行到末尾时，与右边对齐，需要设置两边margin一致
		//由于使用了百分比适配页面宽度，所以需要再计算px单位宽度，避免设置父元素margin时引发幻灯宽度变化
		var ul = box.find('ul');
		var li = box.find('li');
		var itemWidth = li.width();
		li.css('width', itemWidth + 'px');
		ul.css('width', itemWidth * li.length + 'px');

		var marginLeft = parseInt(box.css('margin-left'), 10);
		var marginRight = parseInt(box.css('margin-right'), 10);
		var margin = Math.min(marginLeft, marginRight);
		box.css('margin-left', margin + 'px');
		box.css('margin-right', margin + 'px');
		
		var slide = new $iScroll(box.get(0), {
			disableMouse: true,
			disablePointer: true,
			preventDefault: false,
			eventPassthrough: true,
			scrollX: true,
			scrollY: false,
			momentum: false,
			snap: 'li',
			snapThreshold : 1,
			useTransition: false,
			keyBindings: false
		});

		slide.on('scrollStart', function(){
			links.attr('link-status', 'disabled');
		});
		
		slide.on('scrollEnd',function(){
			links.attr('link-status', '');
			//修复小米手机bug，在滑动的过程中点击元素，滑动结束后背景色不是原来的颜色
			if(xiaomi){
				box.find('[ui-button]').removeClass('active');
			}
		});
		//此处设置最外层元素宽度，是因为在ios8下，左右滑动图集和深度阅读组件，在页面渲染完成后，
		//存在空白情况，即组件位置存在(所占据的高度存在)，可以响应js各种事件，但是内容不显示，
		//怀疑是应用css3动画引起的渲染bug，所以此处设置宽度，触发页面重绘，希望可以让展示正常 
		//先设置，等待后续反馈
		box.css('width',itemWidth * li.length + 'px');
	};

	var buildSlides = function(){
		$(selector).each(function(){
			createIScroll($(this));
		});
	};

	$htmlRender.ready(buildSlides);

	module.exports = {
		init : function(options){
			$.extend(uiconf, options);
		}
	};

});



/**
 * @fileoverview 高清图集幻灯组件
 * @authors xiaoyue3 <xiaoyue3@staff.sina.com.cn>
 */

define('mods/ui/hdSlides',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $iScroll = require('vendor/iscroll5');
	var $bridge = require('mods/bridge/global');
	var $propQuery = require('lib/kit/util/propQuery');
	var $imgbox = require('mods/ui/imgbox');

	var UI_NAME = 'ui-hdslides';
	var selector = '[' + UI_NAME + ']';

	var uiconf = {};

	var ua = navigator.userAgent.toLowerCase();
    var xiaomi = /(xiaomi|miui|(mi 2a))/gi.test(ua);

	var scrollBarOpacity = 0.9;
	if(/N_night/g.test(document.body.className)){
		scrollBarOpacity = 0.5;
	}

	var createIScroll = function(box){
		var links = box.find('[tap-params]');
		//scroller高度为0时，会导致 chrome 的 transition 动画无法执行。
		//因此加上最小1像素的高度。
		var scroller = $(box.children().get(0));
		scroller.css('height', scroller.find('.photo').height() + 'px');

		//目前使用的幻灯，marginLeft和marginRight不一致
		//为了能够让幻灯运行到末尾时，与右边对齐，需要设置两边margin一致
		//由于使用了百分比适配页面宽度，所以需要再计算px单位宽度，避免设置父元素margin时引发幻灯宽度变化
		var marginLeft = parseInt(box.css('margin-left'), 10);
		var marginRight = parseInt(box.css('margin-right'), 10);
		var margin = Math.min(marginLeft, marginRight);
		box.css('margin-left', margin + 'px');
		box.css('margin-right', margin + 'px');

		//页面一进来禁用点击
		links.attr('link-status', 'disabled');

		//发消息函数
		function sendBridgeRequest(el){
			if($imgbox.isEmptyImgbox(el)){
				return;
			}
			var data = el.attr('tap-params');
			data = $propQuery.parse(data);

			if(data.offset){
				data.offset = el.offset();
			}
			if(data.pos){
				data.pos = {};
				var pos = el.get(0).getBoundingClientRect();
				//ios8下 pos对象未能正常解析json字符串 所以遍历属性输出值
				['bottom','height','left','right','top','width'].forEach(function(key){
					data.pos[key] = pos[key];
				});
			}
			var method = data.method;

			$bridge.request(method, {
				data : data
			});
		}

		//初始化滚动实例
		var hdslide = new $iScroll(box.get(0), {
			disableMouse: true,
			disablePointer: true,
			preventDefault: false,
			eventPassthrough: true,
			scrollX: true,
			scrollY: false,
			momentum: true,
			scrollbars: true,
			fadeScrollbars : true,
			useTransition: false,
			keyBindings: false,
			scrollBarOpacity : scrollBarOpacity
		});

		hdslide.on('scrollCancel',function(e){
			hdslide.tapRequestFlag = 1;
			endPos = $(e.target);
		});
		hdslide.on('scrollEnd',function(){
			if(hdslide.tapRequestFlag === 1){
				sendBridgeRequest(endPos.closest('li').find('span'));
				hdslide.tapRequestFlag = 0;
			}
		});

		var winWidth = window.innerWidth;
		var scrollTo = hdslide.scrollTo;
		var els;
		var pagesX = [];
		var liswidth = [];
		var lastTwoPos;
		var endPos;

		function getLiInitPos(){
			//获取里面li结点的左滑动起始位置，方便判断传进来的x在什么位置
			els = hdslide.scroller.querySelectorAll('li');
			for (i=0, l=els.length; i<l; i++) {
				var pos = {
					left : -els[i].offsetLeft
				};
				pagesX[i] = pos.left;
				liswidth[i] = els[i].getBoundingClientRect().width;
			}
			lastTwoPos = -(Math.abs(pagesX[pagesX.length-2])-(winWidth - liswidth[pagesX.length-2])/2-15 + 30);
		}
		getLiInitPos();

		hdslide.scrollTo = function(x, y, time, relative, evt){
			var that = hdslide;
			//去除边界值影响
			if((typeof time === 'number') && x != 0 && x != that.maxScrollX){
				// 倒数第二张图优化
				if( x < lastTwoPos && x > -that.scrollerWidth){
					if(that.directionX === 1){
						x = that.maxScrollX - 20;
						scrollTo.apply(hdslide, [x, y, time]);
						return;
					}
				}
				// 获取传进来的x离哪个元素最近
				var endElIdx;
				pagesX.forEach(function(val,idx){
					if(x > 0){
						endElIdx = 0;
						return;
					}
					if(val<x && x < 0){
						if(typeof endElIdx === 'number'){
							return;
						}
						var prev = pagesX[idx - 1];
						var mid = Math.abs(prev) + ( Math.abs(val) -  Math.abs(prev))/2;
						if(Math.abs(x) > mid){
							endElIdx = idx;
						}else{
							endElIdx = idx - 1;
						}
					}
				});
				//排除最初位置和结束位置
				if(endElIdx && endElIdx >= 1){
					var client =liswidth[endElIdx];
					var minus = (winWidth - client)/2;
					x = Math.abs(pagesX[endElIdx]) - minus;
					//减去组件边距
					x = -x-20+5;
				}
			}
			if(endElIdx === 0 && x < 0){
				x = 30;
			}
			//前面装饰的方法 针对x操作 调用原型链上的方法
			scrollTo.apply(hdslide, [x, y, time]);
		};
	};

	var buildSlides = function(){
		$(selector).each(function(){
			createIScroll($(this));
		});
	};

	$htmlRender.ready(buildSlides);

	module.exports = {
		init : function(options){
			$.extend(uiconf, options);
		}
	};
});

/**
 * @fileoverview 文字区块高度限制
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/ui/textlimit',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $channelApp = require('mods/channel/app');

	var UI_NAME = 'ui-textlimit';
	var selector = '[' + UI_NAME + ']';
	var comment = '.M_comment';
	var uiconf = {};

	var limitText = function(options){
		var conf = $.extend({
			root : null,
			box : null,
			text : null,
			extra : '...'
		}, options);

		var root = $(conf.root);
		var box = root.find(conf.box);
		var text = root.find(conf.text);

		if(box.length === 0){
			box = root;
		}
		if(text.length === 0){
			text = box;
		}

		// 此处需要提前设置节点高度
		if(conf.deepRead){
			var titleHeight = box.prev().height();
			var compHeight = box.closest('ul').height();
			var compPadding = parseInt(box.closest('.M_depth').css('padding-top'), 10);
			var moreHeight = box.closest('.txt').next().height();
			//此处comppadding＊1.5 是因为box里有边距6px 此处需要和设计构建协商
			box.css('height', compHeight - compPadding*1.5 - titleHeight- moreHeight);
		}
		
		var boxNode = box.get(0);
		var textNode = text.get(0);
		var height = box.height();
		var str = text.html();

		var nodesCache = (function(){
			var nodes = [];
			var node = textNode;
			var height;
			while(node.parentNode && node !== boxNode){
				height = $(node).css('height');
				if(height !== 'auto'){
					nodes.push({
						height : height,
						node : node
					});
				}
				node = node.parentNode;
			}
			return nodes;
		})();

		//放开父元素的高度
		nodesCache.forEach(function(item){
			$(item.node).css('height', 'auto');
		});
		var count = str.length;
		if(boxNode.scrollHeight > height){
			//用二分法截取字符串
			var unit = 32;
			var index = 0;
			while((unit > 1) || (boxNode.scrollHeight > height)){
				if(boxNode.scrollHeight > height){
					count = count - unit;
				}else{
					unit = unit / 2;
					count = count + unit;
				}
				text.html(str.slice(0, count) + conf.extra);
				if(conf.commentCon){
					root.next().next().show();
				}
				index ++;
			}
		}

		
		//部分android手机上，未能在循环文字更新后更新scrollHeight值
		//检测发现用计时器打断后可以得到正确的高度，因此在最后阶段使用计时器来循环检测文本内容是否超出区域
		//部分android手机，如果初次timeout设置太短，依然无法取得正确的scrollHeight值
		setTimeout(function(){
			if(boxNode.scrollHeight > height){
				count = count - 1;
				text.html(str.slice(0, count) +conf.extra);
				//更新评论全文按钮是否展示
				if(conf.commentCon){
					root.next().next().show();
				}
				setTimeout(arguments.callee, 10);
			}else{
				//重置父元素的高度
				nodesCache.forEach(function(item){
					$(item.node).css('height', '');
				});
			}
		}, 100);
	};

	var buildTextLimit = function(){
		//评论盖楼字数截取发消息通知
		$channelApp.on('content-load-success', function(rs){
			if(rs && rs.data.type === 'people_comments' || rs && rs.data.type === 'hot_comments'){
				var el = $(comment);
				var node;
				el.each(function(){
					if($(this).attr('data-pl') === rs.data.type ){
						node = $(this);
					}
				});
				if(node && node.length>0){
					node.find(selector).each(function(){
						if($(this).height() === 120){
							limitText({
								root : this,
								text : '[textlimit-role="text"]',
								deepRead : '',
								commentCon : true
							});
						}
					});
				}
			}
		});
		$(selector).each(function(){
			//此组件 只有深度阅读和微博组 两个组件再用 截取文字上有区别，以deepRead标志做区分，请注意！
			var deepReadFlag = $(this).closest('.M_grouptxt').attr('data-pl') === 'deep_read_module';
			var deepExtra = '';
			if(deepReadFlag){
				deepExtra = true;
			}
			//此处添加判断条件，排除评论盖楼字数截取
			if(!$(this).hasClass('f_txt')){
				limitText({
					root : this,
					box : '[textlimit-role="box"]',
					text : '[textlimit-role="text"]',
					deepRead : deepExtra
				});
			}
		});
		// $channelApp.trigger('content-load-success',{
		// 	data : {
		// 		type : 'hot_comments'
		// 	}
		// });
	};
	
	$htmlRender.ready(buildTextLimit);
	

	module.exports = {
		init : function(options){
			$.extend(uiconf, options);
		}
	};

});


/**
 * @fileoverview 负责延迟加载的模块的渲染，负责通知客户端HTML渲染完成的时间
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 * example
	//用下列数据生成html组件，替换所有data-pl为text的元素
	loadContent({
		"data":"文本内容",
		"type":"text"
	});

	//用下列数据生成html组件，替换所有plid为t01的元素
	loadContent({
		"data":"文本内容",
		"type":"text",
		"targetId":"t01"
	});

	//在第一个data-pl为text的元素之前插入2个文本组件
	insertContent({
		data:[
			{
				"data":"文本内容",
				"type":"text"
			},
			{
				"data":"文本内容",
				"type":"text"
			}
		]
	});

	//在第一个plid为t01的元素前面插入2个文本组件
	//在第一个plid为t02的元素前面插入1个文本组件
	insertContent({
		data:[
			{
				"data":"文本内容",
				"type":"text",
				"targetId":"t01"
			},
			{
				"data":"文本内容",
				"type":"text",
				"targetId":"t01"
			},
			{
				"data":"文本内容",
				"type":"text",
				"targetId":"t02"
			}
		]
	});
 */

define('mods/comp/render',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $channelApp = require('mods/channel/app');
	var $channelGlobal = require('mods/channel/global');
	var $bridge = require('mods/bridge/global');

	var compconf = {};

	//用于展示延迟加载的内容
	var loadContent = function(item){
		$htmlRender.ready(function(){
			if(!$.isPlainObject(item)){return;}
			var name = item.type || '';
			var plid = item.targetId || '';
			var html = $htmlRender.renderItem(item);
			if(!html){return;}
			var targetNode = plid ? $('[plid="' + plid + '"]') : $('[data-pl="' + name + '"]');
			targetNode.replaceWith($(html));
			//此处发送消息 主要是在渲染图片的时候 可能节点还没有渲染成功 所以添加此消息 方便客户端什么时候开始渲染图片
			$bridge.request('loadContentSuccess', {
				data : {
					type : name
				}
			});
			$channelApp.trigger('content-load-success',{
				data : {
					type : name,
					data: item.data,
				}
			});
		});
	};

	//用于记录查找到的目标元素
	var targetList = {};

	//用于延迟插入内容
	var insertContent  = function(rs){
		$htmlRender.ready(function(){
			if(!$.isPlainObject(rs)){return;}
			if($.type(rs.data) !== 'array'){return;}

			rs.data.forEach(function(item){
				if(!$.isPlainObject(item)){return;}
				var name = item.type || '';
				var plid = item.targetId || '';
				var html = $htmlRender.renderItem(item);
				if(!html){return;}

				var targetNode;
				//应当记录目标元素，确保插在第一次找到的元素之前
				if(plid){
					targetNode = targetList[name + '_' + plid];
					if(!targetNode){
						targetNode = $('[plid="' + plid + '"]');
						targetList[name + '_' + plid] = targetNode;
					}
				}else{
					targetNode = targetList[name];
					if(!targetNode){
						targetNode = $('[data-pl="' + name + '"]').eq(0);
						targetList[name] = targetNode;
					}
				}

				$(html).insertBefore(targetNode);
			});
		});
	};

	//绑定广播务必在htmlRender.ready之前
	//避免ready事件立即执行时，广播还未绑定的问题。
	$channelApp.on('content-load', loadContent);
	$channelApp.on('content-insert', insertContent);

	setTimeout(function(){
		//推迟ready通知时间，确保各组件广播已绑定
		$htmlRender.ready(function(){
			$bridge.request('htmlReady');
		});
	});

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});

/**
 * @fileoverview 听新闻模块
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/comp/audio',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $view = require('lib/mvc/view');
	var $model = require('lib/mvc/model');
	var $channelApp = require('mods/channel/app');
	var $channelGlobal = require('mods/channel/global');
	var $fixTo = require('lib/kit/num/fixTo');
	var $config = window.$CONFIG || {};
	var compconf = {};

	var AudioPlayer = $view.extend({
		defaults : {
			'tipLoading' : '加载中...',
			'tipError' : '失败了，请检查网络',
			'styleError' : 'listennews listennews_play error_message',
			'stylePlay' : 'listennews listennews_play',
			'stylePause' : 'listennews listennews_pause',
			events : {
				'[data-role="button"] tap' : 'toggle',
				'[data-role="button"] click' : 'checkState'
			}
		},
		build : function(){
			this.id = this.role('root').attr('id');
			this.audio = this.role('audio').get(0);
			this.startTimeHtml = this.role('time').html();
			this.model = new $model({
				state : 'pause'
			});
			this.render();
		},
		setEvents : function(action){
			this.delegate(action);
			var proxy = this.proxy();
			var audio = this.role('audio');
			var model = this.model;
			audio[action]('progress', proxy('onProgress'));
			audio[action]('ended', proxy('reset'));
			audio[action]('error', proxy('onError'));
			model[action]('change:state', proxy('checkState'));
			model[action]('change:state', proxy('render'));
			$channelGlobal.on('notice-audio-pause', proxy('checkNotice'));
		},
		//android部分手机，由于zepto的tap事件相对于touchend有延迟，所以会无法触发音频的首次播放。
		//因此这个方法必须绑在click或者touchend事件上，考虑到用户滚动屏幕的判断，使用click比较合适。
		checkState : function(){
			var model = this.model;
			var state = model.get('state');
			if(this.isPlaying()){
				this.playAudio();
			}else{
				this.pauseAudio();
			}
		},
		checkNotice : function(audio){
			if(audio !== this.audio){
				this.pause();
			}
		},
		playAudio : function(){
			var that = this;
			var audio = this.audio;
			$channelGlobal.trigger('notice-audio-pause', this.audio);
			if(audio){
				if($config.platform === 'android'){
					if(!that.isReady()){
						audio.load();
						this.onProgress();
						//这里延时5秒是因为长音频很容易显示为错误状态
						setTimeout(function(){
							if(!that.isReady()){
								that.onError();
							}else if(that.isPlaying()){
								that.playAudio();
							}
						}, 5000);
						return;
					}
				}
				if(audio.error){
					this.model.set('state', 'error');
					audio.load();
				}else{
					audio.play();
				}
			}
			this.watch();
		},
		pauseAudio : function(){
			var audio = this.audio;
			if(audio){
				audio.pause();
			}
			this.unWatch();
		},
		resetAudio : function(){
			if(this.audio){
				this.audio.load();
			}
			this.setCurrentTime(0);
			this.model.set('state', 'pause');
			this.role('time').html(this.startTimeHtml);
		},
		play : function(){
			this.model.set('state', 'playing');
		},
		pause : function(){
			this.model.set('state', 'pause');
		},
		reset : function(){
			this.resetAudio();
		},
		isPlaying : function(){
			return this.model.get('state') === 'playing';
		},
		render : function(){
			var state = this.model.get('state');
			var conf = this.conf;
			if(state === 'error'){
				this.role('error').html(conf.tipError);
				this.role('box').attr('class', conf.styleError);
			}else{
				this.role('error').html('');
				this.role('box').attr('class', (
					this.isPlaying() ? conf.stylePause : conf.stylePlay
				));
			}
			if($config.platform === 'android' && state === 'playing'){
				//部分android机型，切换gif显示后，不触发重绘，gif不执行动画
				//这里特地触发一次重绘
				window.scrollTo(0, document.body.scrollTop + 1);
				//实测reflow方法无法触发这个重绘，还需要寻找别的方案。
				// this.role('state').reflow();
			}
			this.renderTime();
		},
		toggle : function(){
			if(this.isPlaying()){
				this.pause();
			}else{
				this.play();
			}
		},
		onError : function(evt){
			this.pauseAudio();
			this.setCurrentTime(0);
			this.model.set('state', 'error');
		},
		onProgress : function(evt){
			this.renderTime();
		},
		watch : function(){
			//android机型计时器有可能不准，导致2秒更新一次时间
			//因此提升android机型中对事件的监控频率
			var renderTimeDuration = $config.platform === 'android' ? 100 : 1000;
			if(!this.timer){
				this.timer = setInterval(this.proxy('renderTime'), renderTimeDuration);
			}
			this.renderTime();
		},
		unWatch : function(){
			clearInterval(this.timer);
			this.timer = null;
		},
		setLoading : function(){
			var conf = this.conf;
			if(this.isPlaying()){
				this.role('time').html(this.conf.tipLoading);
			}
		},
		//android部分机型，音频无法播放，但duration不为0，可能会是一个较小的值
		//考虑到实际业务中不存在少于3的duration，这里判断duration少于3，或者音频尚未就绪，直接认为是0(参见isReady的逻辑)
		getDuration : function(){
			var audio = this.audio;
			if(this.isReady()){
				return parseInt(audio.duration, 10) || 0;
			}else{
				return 0;
			}
		},
		//设置currentTime存在兼容性问题，因此使用这个方法替代
		setCurrentTime : function(time){
			var audio = this.audio;
			time = parseInt(time, 10) || 0;
			if(audio){
				try{
					//android 2.3 currentTime属性不可写，在播放完成后自动恢复为0
					audio.currentTime = 0;
				}catch(e){}
			}
		},
		//判断音频是否准备好，是否可以播放
		isReady : function(){
			var audio = this.audio;
			var ready = true;
			if(audio){
				var duration = parseInt(audio.duration, 10) || 0;
				//android部分机型，音频无法播放，但duration不为0，可能会是一个较小的值
				if(!audio.duration || duration <= 3){
					ready = false;
				}
				if(!audio.readyState){
					ready = false;
				}
				if(audio.error){
					ready = false;
				}
			}else{
				ready = false;
			}
			return ready;
		},
		renderTime : function(time){
			var audio = this.audio;
			if(!this.isReady()){
				this.setLoading();
				return;
			}
			time = typeof time === 'undefined' ? audio.currentTime : time;
			time = time || 0;
			var duration = this.getDuration();
			var countDown = Math.max(duration - time, 0);
			var minute = parseInt(countDown / 60, 10) || 0;
			var second = parseInt(countDown % 60, 10) || 0;
			minute = minute >= 10 ? minute : "0" + minute;
			second = second >= 10 ? second : "0" + second;
			this.role('time').html(minute + ':' + second);
			if(time <= 0 && duration > 3){
				this.startTimeHtml = minute + ':' + second;
			}
			//部分android机型，播放完毕，没有ended事件，所以需要判断计时是否为0来重置音频
			if($config.platform === 'android' && countDown <= 0){
				this.reset();
			}
		}
	});
	
	//全部音频播放器
	var players = [];

	var getPlayer = function(id){
		var player;
		if(id){
			players.forEach(function(item){
				if(id === item.id){
					player = item;
					return false;
				}
			});
		}else{
			player = players[0];
		}
		return player;
	};

	var sinaAudio = {
		isPlaying : function(id){
			var player = getPlayer(id);
			if(player){
				return player.isPlaying();
			}
		},
		play : function(id){
			var player = getPlayer(id);
			if(player){
				player.play();
			}
		},
		reset : function(id){
			var player = getPlayer(id);
			if(player){
				player.reset();
			}
		},
		pause : function(id){
			players.forEach(function(item){
				if(item.isPlaying()){
					item.pause();
				}
			});
		}
	};

	var buildAudios = function(){
		$('[data-pl="audio"]').each(function(){
			var el = $(this);
			var player = new AudioPlayer({
				node : this
			});
			players.push(player);
		});
	};

	$htmlRender.ready(buildAudios);

	$channelApp.on('page-blur', function(){
		sinaAudio.pause();
	});

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});


/**
 * @fileoverview 负责通用的杂项任务的处理
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/comp/common',function(require,exports,module){

	var $ = require('lib');
	var $channelApp = require('mods/channel/app');
	var $bridge = require('mods/bridge/global');
	var $propQuery = require('lib/kit/util/propQuery');

	var compconf = {};
	var UI_LINK = 'ui-link';
	var validFont = ['s_small', 's_middle', 's_large', 's_largemore'];

	//监听字体更新事件
	$channelApp.on('font-change', function(rs){
		if(rs){
			if(rs.fontFamily){
				document.body.style.fontFamily = rs.fontFamily;
			}
			if(rs.fontSize){
				var artMain = $('#main_article');
				if(validFont.indexOf(rs.fontSize) !== -1){
					validFont.forEach(function(font){
						artMain.removeClass(font);
					});
					artMain.addClass(rs.fontSize);
				}
				//$('#main_article').attr('class', rs.fontSize);
			}
		}
	});

	//监听白天夜间模式切换
	$channelApp.on('switch-daynight', function(rs){
		if(rs){
			if(rs.dispType === 'night'){
				$('#main_article').addClass('N_night');
			}else{
				$('#main_article').removeClass('N_night');
			}
		}
	});

	//监听更新视频位置
	$channelApp.on('update-video-postion', function(rs){
		if(rs && rs.videoId){
			var el = $('#' + rs.videoId);
			var params = el.attr(UI_LINK);
			params = $propQuery.parse(params);

			if(params.offset){
				params.offset = el.offset();
			}
			if(params.pos){
				params.pos = {};
				var pos = el.get(0).getBoundingClientRect();
				//ios8下 pos对象未能正常解析json字符串 所以遍历属性输出值
				['bottom','height','left','right','top','width'].forEach(function(key){
					params.pos[key] = pos[key];
				});
			}
			delete params.method;

			$bridge.request('getVideoOffset', {
				data : params
			});
		}
	});

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});























/**
 * @fileoverview 媒体订阅推广
 * @authors xiaoyue3 <xiaoyue3@staff.sina.com.cn>
 */

define('mods/comp/mediaSpread',function(require,exports,module){

	var $bridge = require('mods/bridge/global');
	var $htmlRender = require('lib/common/htmlRender');
	var $channelApp = require('mods/channel/app');

	var selector = '[data-pl="media_spread"]';
	var compconf = {};
	var $doc = $(document);

	//构建媒体订阅
	var buildMediaRSS = function(){
		$doc.delegate(selector, 'tap', function(evt){
			var el = $(evt.currentTarget);
			var rssBtn = el.find('.down');
			$bridge.request('requestCallback', {
				timeout : 20 * 1000,
				data : {
					action: "do_rss"
				},
				callback : function(rs){
					if(rs && rs.status === 1){
						rssBtn.html('查看');
					}else{
						rssBtn.html('订阅');
					}
				},
				onTimeout : function(){}
			});
		});
	};

	var updateRssStatus = function(rs){
		var el = $('[plid="media_spread0"]').find('.down');
		if(rs && rs.type === 'do_rss' && rs.status === 0){
			el.html('订阅');
		}else{
			el.html('查看');
		}
	};

	if($CONFIG && $CONFIG.platform === "ios"){
		$channelApp.on('content-load', updateRssStatus);
	}
	
	$htmlRender.ready(buildMediaRSS);

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});























/**
 * @fileoverview 投票模块
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/comp/votes',function(require,exports,module){

	var $htmlRender = require('lib/common/htmlRender');
	var $view = require('lib/mvc/view');
	var $model = require('lib/mvc/model');
	var $tpl = require('lib/kit/util/template');
	var $bridge = require('mods/bridge/global');
	var $mustache = require('vendor/mustache');
	var $delay = require('lib/kit/func/delay');
	var $propQuery = require('lib/kit/util/propQuery');

	var $config = window.$CONFIG || {};
	var compconf = {};

	var TPL = $tpl({
		result : [
			'{{#data.pollResult}}',
			'<div class="q_title">',
				'{{#isRadio}}<span class="q_icon">单选</span>{{/isRadio}}',
				'{{^isRadio}}<span class="q_icon">多选</span>{{/isRadio}}',
				'{{question}}',
			'</div>',
			'<ul class="list2">',
				'{{#answer}}',
				'<li class="{{picked}}">',
					'<div class="tit">',
						'<span>{{name}}</span>',
					'</div>',
					'<div class="range">',
						'<span class="persent{{percent}}" style="width:{{percent}}%;">',
							'<em><b>{{percent}}%</b></em>',
						'</span>',
					'</div>',
					'<div class="icon_result">已选</div>',
				'</li>',
				'{{/answer}}',
			'</ul>',
			'{{/data.pollResult}}',
			'{{#data.isVoted}}',
			'<div class="btn_partake">感谢您的参与</div>',
			'{{/data.isVoted}}',
			'{{^data.isVoted}}',
			'<div class="btn_zone btn_reasult"><div data-role="back" class="btn_q">立即参与</div></div>',
			'{{/data.isVoted}}'
		],
		overdue: [
			'{{#data.pollResult}}',
			'<div class="q_title">',
				'{{#isRadio}}<span class="q_icon">单选</span>{{/isRadio}}',
				'{{^isRadio}}<span class="q_icon">多选</span>{{/isRadio}}',
				'{{question}}',
			'</div>',
			'<ul class="list2">',
				'{{#answer}}',
				'<li class="{{picked}}">',
					'<div class="tit">',
						'<span>{{name}}</span>',
					'</div>',
					'<div class="range">',
						'<span class="persent{{percent}}" style="width:{{percent}}%;">',
							'<em><b>{{percent}}%</b></em>',
						'</span>',
					'</div>',
					'<div class="icon_result">已选</div>',
				'</li>',
				'{{/answer}}',
			'</ul>',
			'{{/data.pollResult}}',
			'<div class="btn_partake">该投票已结束</div>',
		]
	});

	//投票的数据模型
	var VotesModel = $model.extend({
		defaults : {
			uid : '',
			voteId : '',
			data : null,
			formData : null,
			enableSubmit : false,
			timeout : 200 * 1000,
			requesting : false,
			voted : false,
			currentTab : 'question'
		},
		events : {
			'change:voteId' : 'bindData',
			'change:formData' : 'validate'
		},
		build : function(){
			this.voteRecord = {};
			this.validate = $delay(this.validate,100);
		},
		validate : function(){
			var formData = this.get('formData');
			var result = true;
			$.each(formData, function(key, listData){
				if(!listData){
					result = false;
					return false;
				}else if($.type(listData) === 'array' && !listData.length){
					result = false;
					return false;
				}
			});
			this.set('enableSubmit', result);
		},
		//请求投票接口，获取投票数据
		request : function(){
			var that = this;
			var enableSubmit = this.get('enableSubmit');
			var vdata = this.getData();
			var data = vdata.data;
			if(enableSubmit){
				if(this.get('requesting')){
					return;
				}
				this.set('requesting', true);

				var para = {};
				para.action = 'do_vote';
				para.voteId = this.get('voteId');
				para.pollId = data.pollId;
				para.formdata = JSON.stringify(this.get('formData'));

				var timeout = this.get('timeout');
				$bridge.request('request', {
					timeout : timeout,
					data : {
						url : data.voteUrl,
						method : 'post',
						action : para.action,
						data : para
					},
					callback : function(rs){
						if(rs && rs.status === 0){
							$.extend(data, rs.data);
							that.set('uid', data.uid || '');
							if(rs.data.isVoted + '' === '0'){
								that.saveVoteRecord(data.uid, para);
							}
							that.set('voted', true);
							that.set('data', vdata);
							// that.checkOverdue();
							that.set('currentTab', 'result');
						}
						that.set('requesting', false);
					},
					onTimeout : function(){
						that.set('requesting', false);
					}
				});
			}
		},
		requestPK : function(fn){
			var that = this;
			var vdata = this.getData();
			var data = vdata.data;
			if(this.get('requesting')){
				return;
			}
			this.set('requesting', true);

			var para = {};
			para.action = 'do_vote';
			para.voteId = this.get('voteId');
			para.pollId = data.pollId;
			para.formdata = JSON.stringify(this.get('formData'));
			var timeout = this.get('timeout');
			$bridge.request('request', {
				timeout : timeout,
				data : {
					url : data.voteUrl,
					method : 'post',
					action : para.action,
					data : para
				},
				callback : function(rs){
					if(rs && rs.status === 0){
						$.extend(data, rs.data);
						that.set('uid', data.uid || '');
						if(rs.data.isVoted + '' === '0'){
							that.saveVoteRecord(data.uid, para);
						}
						that.set('voted', true);
						that.set('data', vdata);
						if(fn){
							fn();
						}
					}
					that.set('requesting', false);
				},
				onTimeout : function(){
					that.set('requesting', false);
				}
			});
		},
		//直接获取投票结果
		getResult : function(fn){
			var that = this;
			var timeout = this.get('timeout');
			var vdata = this.getData();
			var data = vdata.data;

			if(this.get('requesting')){
				return;
			}
			this.set('requesting', true);

			var para = {};
			para.action = 'get_vote_result';
			para.voteId = this.get('voteId');
			para.pollId = data.pollId;

			$bridge.request('request', {
				timeout : timeout,
				data : {
					url : data.voteUrl,
					method : 'post',
					action : para.action,
					data : para
				},
				callback : function(rs){
					if(rs && rs.status === 0){
						$.extend(data, rs.data);
						that.set('voted', rs.data.isVoted + '' === '1');
						that.set('uid', data.uid || '');
						that.set('data', vdata);
						// that.checkOverdue();
						//fn && fn(); // 执行动作前进行校验
						that.set('currentTab', 'result');
					}
					that.set('requesting', false);
				},
				onTimeout : function(){
					that.set('requesting', false);
				}
			});
		},
		//保存投票记录
		saveVoteRecord : function(uid, para){
			if(!uid || !para){return;}
			if(this.get('voted')){return;}
			var voteRecord = this.voteRecord || {};
			var recordKey = uid + '_' + para.voteId;

			//用一个队列确保投票记录数据不超过一定数量
			//避免存储数据过大导致无法记录
			if(!voteRecord.queue){
				voteRecord.queue = [];
			}
			if(voteRecord.queue.length >= 200){
				var key = voteRecord.queue.shift();
				delete voteRecord[key];
			}

			if(!voteRecord[recordKey]){
				voteRecord.queue.push(recordKey);
			}
			voteRecord[recordKey] = para;
			this.voteRecord = voteRecord;
		},
		//格式化投票的原始数据
		formatData : function(rs){
			var uid = this.get('uid');
			var lists = rs.data.pollQuestion.concat(rs.data.pollResult);
			lists.forEach(function(question){
				var isRadio = question.questionState + '' === '1';
				if(isRadio){
					question.isRadio = 1;
				}
				question.answer.forEach(function(answer){
					answer.questionId = question.questionId;
					answer.input_type = isRadio ? 'radio' : 'checkbox';
				});
			});
			rs.data.isEnded = rs.data.pollState + '' !== '1';
			rs.data.isVoted = this.get("voted");

			//检查本地的投票记录
			if(uid){
				var recordKey = uid + '_' + rs.data.voteId;
				var voteRecord = this.voteRecord || {};
				var record = voteRecord[recordKey];
				if(record && record.formdata){
					var formData = JSON.parse(record.formdata) || {};
					rs.data.pollResult.forEach(function(result){
						var qid = 'q_' + result.questionId;
						var recordAnswer = formData[qid];
						if(!recordAnswer){return;}
						if(!$.isArray(recordAnswer)){
							recordAnswer = [recordAnswer];
						}
						if(recordAnswer.length && $.isArray(result.answer)){
							result.answer.forEach(function(answer){
								answer.answerId = answer.answerId + '';
								if(recordAnswer.indexOf(answer.answerId) >= 0){
									answer.picked = 'active';
								}
							});
						}
					});
				}
			}
			return rs;
		},
		//绑定投票的原始数据
		bindData : function(){
			var that = this;
			var voteId = this.get('voteId');
			if($config.pageData && $.type($config.pageData.data) === 'array'){
				$config.pageData.data.forEach(function(data){
					if(data.type === 'vote'){
						if(data.data && data.data.voteId === voteId){
							that.set('data', data);
						}
					}
				});
			}
		},
		//获取投票的数据
		getData : function(){
			var data = this.get('data');
			return this.formatData(data);
		},
		toggle : function(){
			var currentTab = this.get('currentTab');
			if(currentTab === 'result'){
				this.set('currentTab', 'question');
			}else{
				this.getResult();
			}
		}
	});
	//投票的视图组件
	var Votes = $view.extend({
		defaults : {
			role:{
				up : '[vote-up]',
				down : '[vote-down]'
			},
			events : {
				'[data-role="question"] li touchend' : 'preventDefault',
				'[data-role="question"] li click' : 'preventDefault',
				'[data-role="question"] li tap' : 'pick',
				'[data-role="toggle"] tap' : 'toggle',
				'[data-role="back"] tap' : 'toggle',
				'[data-role="submit"] tap' : 'submit',
				'input change' : 'validate'
			}
		},
		build : function(){
			this.vm = new VotesModel();
			this.bindData();
			//this.vm.set('timeout', 0);
			if(this.checkOverdue()){
				this.showResult();
				this.voteDone = true;
				return;
			}
			this.checkSubmit();
			this.checkCurrentTab();
			this.voteDone = false;

		},
		setEvents : function(action){
			this.delegate(action);
			var that = this;
			var proxy = this.proxy();
			var vm = this.vm;
			vm[action]('change:currentTab', proxy('checkCurrentTab'));
			vm[action]('change:enableSubmit', proxy('checkSubmit'));
		},
		preventDefault : function(evt){
			if(evt && evt.preventDefault){
				evt.preventDefault();
			}
		},
		bindData : function(){
			var voteId = this.role('root').attr('data-voteid');
			this.vm.set('voteId', voteId);
		},
		//获取表单数据
		getFormData : function(){
			var root = this.role('root');
			var formData = {};
			root.find('[qid]').each(function(){
				var list = $(this);
				var input = list.find('input');
				var qid = list.attr('qid');
				var result = '';
				if(input.attr('type') === 'radio'){
					$.each(input, function(){
						var el = $(this);
						if(el.get(0).checked){
							result = el.attr('id');
							return false;
						}
					});
				}else if(input.attr('type') === 'checkbox'){
					result = [];
					$.each(input, function(){
						var el = $(this);
						if(el.get(0).checked){
							result.push(el.attr('id'));
						}
					});
				}
				formData['q_' + qid] = result;
			});
			return formData;
		},
		getPkData : function(el,data){
			var formData = {};
			formData['q_' + data.qid] = data.id;
			return formData;
		},
		//选中一个选项
		pick : function(evt){
			var li = $(evt.currentTarget);
			var input = li.find('input');
			var type = input.attr('type');
			if(type === 'radio'){
				input.get(0).checked = true;
			}else if(type === 'checkbox'){
				input.get(0).checked = !input.get(0).checked;
			}
			this.validate();
		},
		//验证表单
		validate : function(){
			var formData = this.getFormData();
			this.vm.set('formData', formData);
		},
		validatePK : function(el,data){
			var formData = this.getPkData(el,data);
			this.vm.set('formData', formData);
		},
		dealNum : function(num){
			var leng = num.toString().length;
			if(num < 100000){
				return num;
			}else if(num >= 100000 && num <= 9999999){
				return num.toString().substring(0,leng - 4) + '万';
			}else if(num > 9999999){
				return '999万+';
			}
		},
		pkNumFormate:function(el,data) {
			var obj = {};
			//此处需要格式化数字
			//debugger
			var num = data.count;
			var reg = /(9{4})$/gi;
			var wrap = $(el.children().get(0));
			var spectial = parseInt(num.replace(reg,''),10);
			if(reg.test(num) &&  spectial>=9){
				wrap.html((spectial + 1 )+ '万');
			}else if(num >= 100000 && num <= 9999999){
				wrap.html(num.toString().substring(0,num.toString().length - 4) + '万');
			}else{
				wrap.html(parseInt(num,10) + 1);
			}
			// $(el.children().get(1)).addClass('on');
			var otherNum;
			if(el.prev().hasClass('pk_side')){
				obj.otherNum = $propQuery.parse(el.prev().attr('params')).count;
				otherNum = this.dealNum(obj.otherNum);
				$(el.prev().children().get(0)).html(otherNum);
			}else{
				obj.otherNum = $propQuery.parse(el.next().attr('params')).count;
				otherNum = this.dealNum(obj.otherNum);
				$(el.next().children().get(0)).html(otherNum);
			}
			return obj;
		},
		animateStart : function(el,percent,other){
			el.transit({
				'width' : 100 + '%'
			}, 500, 'ease-out', function(){
				other.css('width', (percent.oth+1) + '%');
				el.transit({
					'width' : percent.cur + '%'
				}, 500, 'ease-out',$.loop);
			});
		},
		attachIcon : function(el){
			$(el.children().get(1)).addClass('on');
		},
		setLineStyle : function(type,up,down){
			if(type === "up"){
				up.css('z-index',1);
				down.css('z-index',0);
			}else{
				up.css('z-index',0);
				down.css('z-index',1);
			}
		},
		//获取pk的百分比
		getPkPercent : function(current,other){
			var num = $(current).html();
			var reg = /万/gi;
			if(reg.test(num)){
				num = num.replace(/\+/g,'');
				num = parseInt(num,10) + '0000';
			}
			var total = parseInt(num,10) + parseInt(other.otherNum,10);
			return {
				cur : Math.ceil((num/total) * 100),
				oth : Math.floor(100 - (num/total) * 100)
			};
		},
		//提交表单
		submit : function(e){
			var el = $(e.target).closest('.pk_side');
			var type = el.attr('type');
			if(type && (type === 'support'|| type === 'oppose')){
				if(this.voteDone){
					return;
				}
				var up = this.role('up');
				var down = this.role('down');
				var btns = el.parent().children();
				var upEl = $(btns.get(0)).children().get(0);
				var downEl = $(btns.get(1)).children().get(0);
				var data = $propQuery.parse(el.attr('params'));
				this.validatePK(el,data);
				var otherNum;
				var that = this;
				if(type === 'support'){
					this.vm.requestPK(function(){
						//debugger
						if(that.checkOverdue()){
							that.showResult();
						}else{
							otherNum = that.pkNumFormate(el,data);
							var upPercent = that.getPkPercent(upEl,otherNum);
							that.setLineStyle('up',up,down);
							that.animateStart(up,upPercent,down);
							that.attachIcon(el);
							that.voteDone = true;
						}
					});
				}
				if(type === 'oppose'){
					this.vm.requestPK(function(type){
						//debugger;
						if(that.checkOverdue()){
							that.showResult();
						}else{
							otherNum = that.pkNumFormate(el,data);
							var downPercent = that.getPkPercent(downEl, otherNum);
							that.setLineStyle('down',up,down);
							that.animateStart(down,downPercent,up);
							that.attachIcon(el);
							that.voteDone = true;
						}
					});
				}
			}else{
				this.vm.request(function(){
					that.checkOverdue();
				});
			}
		},
		//切换显示结果界面和投票界面
		toggle : function(evt){
			var el = $(evt.currentTarget);
			this.vm.toggle();
		},
		//渲染结果数据&过期投票
		renderResult : function(){
			//debugger
			var voteData = this.vm.getData();
			var tpl = this.vm.get('isOverdue') ? TPL.get('overdue') : TPL.get('result');
			var html = $mustache.render(tpl, voteData);
			var elResult = this.role('result');
			var elVoterNum = this.role('voternum');
			elResult.html(html);
			elVoterNum.html(
				'(' + voteData.data.voterNum + '人参与)'
			);
			//为避免百分比文案与已选按钮重叠，需要计算.range元素的最大宽度
			elResult.find('.range').css('width', window.innerWidth - 160 + 'px');
		},
		//检查投票是否过期
		checkOverdue: function(){
			// debugger
			var voteData = this.vm.get('data'),
				isOverdue;
			// if(voteData && voteData.data && voteData.data.pkStyleFlag === 1){
			// 	this.vm.set('isOverdue', false);
			// 	isOverdue = false;
			// }
			isOverdue = !!(voteData && voteData.data && voteData.data.pollState === '0');
			this.vm.set('isOverdue', isOverdue);
			return isOverdue;
			// return isOverdue;
		},
		//渲染提交按钮的状态
		checkSubmit : function(){
			var enableSubmit = this.vm.get('enableSubmit');
			var buttonSubmit = this.role('submit');
			if(enableSubmit){
				buttonSubmit.removeClass('gray');
				buttonSubmit.attr('ui-button', '');
			}else{
				buttonSubmit.addClass('gray');
				buttonSubmit.removeAttr('ui-button');
			}
		},
		//检查显示哪一个面板
		checkCurrentTab : function(){
			var currentTab = this.vm.get('currentTab');
			if(currentTab === 'result'){
				this.showResult();
			}else{
				this.showQuestion();
			}
		},

		//显示结果&过期界面
		showResult : function(){
			this.checkOverdue();
			var vm = this.vm;
			var elToggle = this.role('toggle');
			var vdata = vm.getData();
			var pkOverdue = vm.get('isOverdue') && vdata.data.pkStyleFlag === 1;
			var voteOverdue = vm.get('isOverdue') && vdata.data.pkStyleFlag !== 1;
			var hadVote = !vm.get('isOverdue') && vm.get('voted');
			//debugger
			if(pkOverdue){
				// debugger
				var up = this.role('up');
				var down = this.role('down');
				var btns = this.role('submit');
				var overdusign = this.role('overdueSign');
				var el = btns.eq(0);
				var upEl = $(btns.get(0)).children().get(0);
				var downEl = $(btns.get(1)).children().get(0);
				var data = $propQuery.parse(el.attr('params'));
				var otherNum = this.pkNumFormate(el,data);
				var upPercent = this.getPkPercent(upEl,otherNum);
				overdusign.show();
				this.animateStart(up,upPercent,down);
				this.voteDone = true;
				return;
			}else if(voteOverdue){
				elToggle.addClass('end');
				elToggle.removeAttr('data-role');
				elToggle.html('已结束');
			}else if(hadVote){
				elToggle.addClass('end');
				elToggle.removeAttr('data-role');
				elToggle.html('已投票');
			}else{
				elToggle.html('参与投票');
			}
			this.renderResult();
			this.role('question').hide();
			this.role('result').show();
		},
		//显示问题界面
		showQuestion : function(){
			var elToggle = this.role('toggle');
			elToggle.html('查看结果');
			this.role('question').show();
			this.role('result').hide();
		}
	});

	//构建投票
	var buildVotes = function(){
		$('[data-pl="vote"]').each(function(){
			var el = $(this);
			var votes = new Votes({
				node : this
			});
		});
	};

	$htmlRender.ready(buildVotes);

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});


/**
 * @fileoverview 评论点赞  评论盖楼加全文展开
 * @authors yifei2 <yifei2@staff.sina.com.cn>
 */

define('mods/comp/commentLike',function(require,exports,module){

	var $bridge = require('mods/bridge/global');
	var $htmlRender = require('lib/common/htmlRender');
	var $propQuery = require('lib/kit/util/propQuery');


	var selector = '[click-type="comment-like"]';
	var compconf = {};
	var $doc = $(document);
	var UI_PARAM = 'ui-param';
	// 构建评论赞
	var buildCommentLike = function(){
		$doc.delegate(selector, 'tap', function(evt){
			var el = $(evt.currentTarget);
			var params = el.attr(UI_PARAM);
			params = $propQuery.parse(params);

			//5.2
			//状态记录在本地，如果已经点赞过，则不执行之后的请求
			//不在本地判断，客户端来判断
			// if(el.hasClass('on')){
			// 	return;
			// }

			if(params.offset){
				params.offset = el.offset();
			}
			if(params.pos){
				params.pos = {};
				var pos = el.get(0).getBoundingClientRect();
				//ios8下 pos对象未能正常解析json字符串 所以遍历属性输出值
				['bottom','height','left','right','top','width'].forEach(function(key){
					params.pos[key] = pos[key];
				});
			}
			$bridge.request('requestCallback', {
				timeout : 200 * 1000,
				data : {
					action: "do_comment_like",
					params : params
				},
				callback : function(rs){
					if(rs && rs.status === 1){
						// 赞的数字+1
						el.addClass('on');
						var text = el.text();
						if(/万/gi.test(text)){
							el.html('<em></em>' + text);
						}else{
							var curNum = parseInt(text, 10) || 0;
							if(curNum === 0) {
								el.html('<em></em>1');
							}else {
								if(curNum + 1 >=100000){
									el.html('<em></em>' + '10万');
								}else{
									el.html('<em></em>' + (curNum + 1));
								}
								
							}
						}
					}
				},
				onTimeout : function(){}
			});
		});
	};
	$htmlRender.ready(buildCommentLike);

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});

/**
 * @fileoverview 评论盖楼加全文展开
 * @authors xiaoyue3 <xiaoyue3@staff.sina.com.cn>
 */

define('mods/comp/commentFloor',function(require,exports,module){
	var $htmlRender = require('lib/common/htmlRender');
	
	var selector = {
		contentAllBtn: '[click-type="comment-content-all"]',
		floorBox: '[data-role="hot_cmnt_floor_box"]',
		floorItems: '[data-role="hot_cmnt_floor"]',
		floorAllBtn: '[click-type="cmnt-floor-all"]'
	};

	var compconf = {};
	var $doc = $(document);
	var cmntMap = {};
	// 构建评论盖楼
	var buildCommentFloor = function(){
		//显示全文
		$doc.delegate(selector.contentAllBtn, 'tap', function(evt){
			var el = $(evt.currentTarget);
			el.prev().prev().hide();
			el.prev().show();
			el.hide();
		});
		$doc.delegate(selector.floorAllBtn, 'tap', function(evt){
			var el = $(this);
			var index = el.data('index');
			el.hide();
			if(index !== null){
				cmntMap[index].floors.forEach(function($elem){
					$elem.show();
				});
			}
		});
		$doc.delegate(selector.floorAllBtn, 'tap', function(evt){
			var el = $(this);
			var index = el.data('index');
			el.hide();
			if(index !== null){
				cmntMap[index].floors.forEach(function($elem){
					$elem.show();
				});
			}
		});
		//隐藏楼层
		var allFloorBox = $(selector.floorBox);
		allFloorBox.forEach(function(elem, index){
			var $elem = $(elem);
			var floorItems = $elem.find(selector.floorItems);
			if(floorItems.length > 5){
				cmntMap[index] = {
					node: $elem,
					floors: [],
				};
				for(var i=3,len=floorItems.length; i < len-2; i++){
					floorItems.eq(i).hide();
					cmntMap[index].floors.push(floorItems.eq(i));
				}
				floorItems.eq(len-2).before('<div class="floor show_all_repaly" click-type="cmnt-floor-all" data-index="'+index+'">显示隐藏的评论</div>');
			}else if(floorItems.length === 0){
				$elem.hide();
			}
		});

	};

	$htmlRender.ready(buildCommentFloor);

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});
/**
 * @fileoverview gif图片特殊处理
 * @authors xiaoyue3 <xiaoyue3@staff.sina.com.cn>
 */

define('mods/ui/gifLoad',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $channelGlobal = require('mods/channel/global');
	var $bridge = require('mods/bridge/global');
	var $delay = require('lib/kit/func/delay');
	var $config = window.$CONFIG || {};

	var winHeight = window.innerHeight;
	var compconf = {
		styleError : 'C_download'
	};
	var gifData;
	
	//获取gif图片进入替换的地址
	var getDataSrc = function(imgNode){
		imgNode = $(imgNode);
		var tempData = {};
		if($CONFIG.platform === 'ios' && imgNode.hasAttr('data-src')){
			tempData.enterSrc = imgNode.attr('data-src');
		}

		if($CONFIG.platform === 'android' && imgNode.hasAttr('data-gif')){
			tempData.enterSrc = imgNode.attr('data-gif');
		}

		if(imgNode.hasAttr('data-src')){
			tempData.leaveSrc = imgNode.attr('data-src');
		}

		return tempData;
	};

	function sendGifEnterMessage(data){
		if(data.el.attr('flag') === '0'){
			data.el.attr('flag', '1');
			if($config.osVersion === 1){
				data.icon.hide();
			}else{
				data.icon.addClass('Am_fadeout');
			}
			data.loading.show();
			//此处发消息会有丢失的情况下，主要是由于页面视窗内会有可能两到三张图片，
			//一起发消息，消息密集，由于底层iframe发消息,是以队列的形式发送，会存
			//在消息丢失的可能。现修改底层消息方式发送，改为每次创建iframe发消息即可
			$bridge.request('gifEnterScreen', {
				timeout:30000,
				data : {
					target : data.src.enterSrc,
					//extra此字段android专用 主要是下载gif完成的时候imgload替换静态图 不影响普通图的下载
					extra :data.src.leaveSrc
				}
			});
		}
	}

	function sendGifLeaveMessage(data){
		if(data.el.attr('flag') === '1'){
			data.el.attr('flag', '0');
			if($config.osVersion === 1){
				data.icon.show();
			}else{
				data.icon.removeClass('Am_fadeout');
			}
			data.loading.hide();
			$bridge.request('gifLeaveScreen', {
				data : {
					target : data.src.leaveSrc
				}
			});
		}
	}
	
	function scrollGifLoad(){
		// 滚去的高度
		var sTop = $(window).scrollTop();
		// 窗口的高度
		var iHeight = winHeight;
		gifData.forEach(function(item){
			if(!item.icon.length){
				return;
			}
			//此处计算位置是因为元素相对视窗的位置不断在变化
			var pos = item.el.get(0).getBoundingClientRect();
			if(sTop + iHeight >= item.top){
				if((iHeight - pos.top >0 && pos.bottom - item.height > 0) ||
					(pos.top > - item.height && pos.bottom > 0)
				){
					sendGifEnterMessage(item);
				}else if(pos.top <= -item.height && pos.bottom <=0){
					sendGifLeaveMessage(item);
				}
			}else{
				sendGifLeaveMessage(item);
			}
		});
	}

	function getAllGifData(){
		var gifList = [];
		$('[data-pl="pic"]').each(function(){
			var el = $(this);
			var temp = {};
			temp.el = el;
			temp.img = el.find('img');
			temp.imgbox = el.find('img').parent();
			temp.icon = el.find('span');
			temp.loading = el.find('.C_gifloading');
			temp.src = getDataSrc(temp.img);
			temp.top = el.offset().top;
			temp.height = el.height();
			gifList.push(temp);
		});
		return gifList;
	}

	var buildGifScrollScreenLoad = function(){
		if($('[data-pl="pic"]').find('span').length){
			gifData = getAllGifData();
			scrollGifLoad();
			$(window).on('scroll',scrollGifLoad);
		}
	};
	//发htmlReady事件添加了延时设置，导致gif一进来发消息会在htmlrReady之前，所以此处添加延时。
	setTimeout(function(){
		$htmlRender.ready(buildGifScrollScreenLoad);
	});

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};
});

/**
 * @fileoverview 正文顶，踩功能
 * @authors xiaoyue3 <xiaoyue3@staff.sina.com.cn>
 */

define('mods/comp/digger',function(require,exports,module){

	var $bridge = require('mods/bridge/global');
	var $htmlRender = require('lib/common/htmlRender');
	var $channelApp = require('mods/channel/app');

	var selector = '[click-type="digger"]';
	var compconf = {};
	var $doc = $(document);

	var isNight = $doc.hasClass('N_night');

	var data = {};
	var tmpFlagState, scrollFlag, isPublish = false, bindeEventFlag;
	var lfLine, rgLine, attitude, tip, wrapper, wrap, lineWrap;
	
	//公用效果集合
	var common = {
		opacity : function(el,val){
			el.transit({
				'opacity': val
			}, 1000, 'ease-out',$.loop);
		}
	};
	//图片文字效果集
	var transitImgTxt = {
		scale : function(el){
			el.transit({
				'scale' : 1.4,
				'opacity': 0
			}, 1000, 'ease-out',$.loop);
		},
		middleState : function(el){
			el.show();
			el.transform({
				'scale':0.7
			});
		},
		endState : function(prev,next){
			prev.transit({
				'scale' : 1,
				'opacity': 1
			}, 600, 'ease-out',function(){
				next.transform({
					'scale':1
				});
			});
		}
	};
	//线处理方法
	var transitLine = {
		widthChange : function(el, percent){
			el.transit({
				'opacity': 1,
				'width' : percent + '%'
			}, 1000, 'ease-out', $.loop);
		}
	};
	//文字数值变化
	function textChange(el){
		if(!/万/g.test(el.text())){
			var num = parseInt(el.text(),10);
			if(num < 100000){
				if(data.type === 0){
					el.text(num - 1);
				}else{
					if(num === 99999){
						el.text(10 + '万');
					}else{
						el.text(num + 1);
					}
				}
			}
		}
	}
	//线的变化
	function lineChange(){
		var icons = wrap.find('.p_act');
		var leftWidth = $(icons.get(0)).width();
		var rightWidth = $(icons.get(1)).width();
		var lineWidth = wrap.width() - leftWidth - rightWidth;
		lineWrap.css({
			'opacity': '1',
			'width': lineWidth + 'px',
			'left' : leftWidth + 'px'
		});
		lineWrap.show();

		var rnum = $(lineWrap.prev().find('.dig_num').children().get(0)).text();
		var lnum = $(lineWrap.next().find('.tread_num').children().get(0)).text();
		if(/万/g.test(rnum)){
			rnum = parseInt(rnum,10) + '0000';
		}
		if(/万/g.test(lnum)){
			lnum = parseInt(lnum,10) + '0000';
		}
		var red = parseInt(rnum,10);
		var blue = parseInt(lnum,10);
		$(lfLine).css('width', 0);
		$(rgLine).css('width', 0);
		transitLine.widthChange($(lfLine), red/(red+blue)*100);
		transitLine.widthChange($(rgLine), blue/(red+blue)*100);
		lineWrap.transit({
			'opacity': 1
		}, 1000, 'ease-out', $.loop);
	}

	function contentShow(num){
		var topNum = $(content.children().get(0));
		var bottomNum = $(content.children().get(1));
		if(data.action === 'do_attitude_praise'){
			topNum.show();
			bottomNum.hide();
			if(num.text() != '1'){
				$(topNum.find('span').get(0)).text(num.text());
			}
		}else{
			bottomNum.show();
			topNum.hide();
			if(num.text() != '1'){
				$(bottomNum.find('span').get(0)).text(num.text());
			}
		}
		//第一次 顶 或 踩
		content.show();
	}
	//内容区域的展示
	function transitContent(num){
		contentShow(num);
		content.css({
			'opacity' : 0
		});
		content.transit({
			'opacity': 1
		}, 1000, 'ease-out', function(){});
	}
	//点击顶踩动画效果显示
	function animationshow(obj){
		//点击顶，首先判断用户是否表态，如果表态,则取消昵称
		//图片放大
		transitImgTxt.scale(obj.prevImg);
		transitImgTxt.scale(obj.prevNum);
		obj.gray.addClass('lose');

		//填充的图片,文字延时0.2s,时长600ms
		setTimeout(function(){
			transitImgTxt.middleState(obj.nextImg);
			transitImgTxt.middleState(obj.nextNum);
			//数字变化的处理
			textChange(obj.nextNum);

			//图片放大0.7-1 透明度0-1
			transitImgTxt.endState(obj.nextImg,obj.prevImg);
			//文字放大
			transitImgTxt.endState(obj.nextNum,obj.prevNum);
		},200);

		//线条出现
		setTimeout(function(){
			lineChange();
		},400);

		//转发微博 tip消失
		setTimeout(function(){
			//tip消失 内容渐显出现
			tip.transit({
				'opacity': 0
			}, 1000, 'ease-out',function(){
				//小米2a下 会出现内容和tip重叠的情况，由于复现概率低，所以此处强制设置透明度为0
				//ios 在动画改版之前也遇到过此问题，所以此处不做区分处理
				tip.css({
					'opacity': 0
				});
				//内容区域变化
				transitContent(obj.nextNum);
			});
		},200);

		setTimeout(function(){
			//必须等到动画结束 才可以执行下一次动画
			isPublish = false;
			//给客户端发送正确的顶踩状态
			if(data.action === 'do_attitude_praise'){
				wrap.attr('attitude','praise');
			}else{
				wrap.attr('attitude','dispraise');
			}
		},1500);
	}
	//取消顶踩操作动画效果
	function animationHide(obj){
		//数字变化的处理
		textChange(obj.nextNum);
		//图片文字消失效果
		[obj.nextImg, obj.nextNum, lineWrap].forEach(function(item){
			common.opacity(item, 0);
		});
		[obj.prevImg, obj.prevNum].forEach(function(item){
			common.opacity(item, 1);
		});
		//移除灰色态
		obj.gray.removeClass('lose');
		//content消失 tip显示
		content.transit({
			'opacity': 0
		}, 500, 'ease-out',function(){
			tip.transit({
				'opacity': 1
			}, 500, 'ease-out',$.loop);
		});
		
		setTimeout(function(){
			isPublish = false;
			wrap.attr('attitude','0');
		},1100);
	}

	//自动播放动画
	function autoPlayAnimation(){
		// 滚去的高度
		var sTop = $(window).scrollTop();
		// 窗口的高度
		var iHeight = window.innerHeight;
		var pos = wrapper.get(0).getBoundingClientRect();
		data.action = attitude==='praise'?'do_attitude_praise':attitude==='dispraise'? 'do_attitude_dispraise': '';
		if(sTop + iHeight >= wrapper.offset().top){
			//必须等到动画结束才可以执行
			if(isPublish){
				return;
			}
			isPublish = true;
			if(attitude != '0'){
				data.type = 1;
				scrollFlag = true;
				lineChange();
				setTimeout(function(){
					isPublish = false;
					if(data.action === 'do_attitude_praise'){
						wrap.attr('attitude','praise');
					}else{
						wrap.attr('attitude','dispraise');
					}
				},1200);
			}
		}
	}
	//获取常用节点
	function getOperateNode(){
		wrapper = $('[data-pl="attitude"]');
		lfLine = $('.sub_bar').get(0);
		rgLine = $('.sub_bar').get(1);
		tip = $('[attitude-share]');
		wrap = $('[attitude]');
		content = $('[attitude-content]');
		attitude = wrap.attr('attitude');
		lineWrap = $(lfLine).parent();
	}

	//绑定事件初始化
	function bindeEvent(){
		//顶踩点击操作
		$doc.delegate(selector, 'tap', function(evt){
			//灰色按钮 不可点击
			var el = $(this);
			if(el.find('.hand_pic').hasClass('lose')){
				return;
			}
			//必须等到动画结束才可以执行
			if(isPublish){
				return;
			}
			isPublish = true;
			//css 开启硬件加速
			// wrap.transform({
			// 	'translateZ' : 0
			// });
			content.transform({
				'translateZ' : 0
			});
			//判断用户点击的是顶,还是踩
			var type = el.attr('attitude-type');
			//获取图片手型icon
			var img = el.find('.hand_pic').children();
			//获取数字节点
			var num;
			//寻找对应置灰色
			var gray;
			attitude = wrap.attr('attitude');
			if(type === 'top'){
				data = {
					action: "do_attitude_praise",
					type : attitude === '0'? 1 : attitude === 'praise'? 0 : 1 //获取用户是否顶踩
				};
				gray = el.next().next().find('span');
				num = el.find('.dig_num').children();
			}else{
				data = {
					action: "do_attitude_dispraise",
					type : attitude === '0'? 1 : attitude === 'dispraise'? 0 : 1 //获取用户是否顶踩
				};
				gray = el.prev().prev().find('span');
				num = el.find('.tread_num').children();
			}

			data.share = tip.hasClass('on');
			var options = {
				prevImg : $(img.get(1)),
				nextImg : $(img.get(0)),
				prevNum : $(num.get(1)),
				nextNum : $(num.get(0)),
				gray : gray
			};
			$bridge.request('requestCallback', {
				timeout : 90 * 1000,
				data : data,
				callback : function(rs){
					if(rs && rs.status === 1){
						if(data.type){
							animationshow(options);
						}else{
							animationHide(options);
						}
					}else{
						isPublish = false;
					}
				},
				onTimeout : function(){
					isPublish = false;
				}
			});
		});

		//表态到微博点击事件
		$doc.delegate('[attitude-share]', 'tap', function(evt){
			var elem = $(this);
			var share = elem.hasClass('on');
			if(share){
				elem.removeClass('on');
				$bridge.request('diggerSendWeibo',{
					data:{
						type : 0
					}
				});
			}else{
				elem.addClass('on');
				$bridge.request('diggerSendWeibo',{
					data:{
						type : 1
					}
				});
			}
		});

		//同步顶踩转发微博状态
		$channelApp.on('digger-weibo-status-synch', function(rs){
			if(rs && rs.data){
				if(rs.data.status === 1){
					tip.addClass('on');
				}
				if(rs.data.status === 0){
					tip.removeClass('on');
				}
			}
		});
	}
	//构建文章顶踩功能
	var buildArticleAttitude = function(){
		getOperateNode();
		if(attitude != '0'){
			autoPlayAnimation();
			$(window).on('scroll',function(){
				if(scrollFlag){
					return;
				}
				autoPlayAnimation();
			});
		}
		//禁止重复绑定事件
		if(!bindeEventFlag){
			bindeEvent();
			bindeEventFlag = true;
		}
	};

	$htmlRender.ready(function(){
		$channelApp.on('content-load-success', function(rs){
			if(rs && rs.data.type === 'attitude'){
				buildArticleAttitude();
			}
		});
		// $channelApp.trigger('content-load-success',{
		// 	data : {
		// 		type : 'attitude'
		// 	}
		// });
		// setTimeout(function(){
		// 	$channelApp.trigger('digger-weibo-status-synch',{
		// 		data : {
		// 			status : 0
		// 		}
		// 	});
		// },2000);
	});

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});























/**
 * @fileoverview 负责连接h5到native 分享接口
 * @authors yuanfeng <yuanfeng@staff.sina.com.cn>
 */

define('mods/comp/shareEntry',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $channelGlobal = require('mods/channel/global');
	var $bridge = require('mods/bridge/global');
	var validShare = ['qq', 'weixin', 'weibo', 'friends'];
	var shareSelector = '[click-type="goto-share"]';
	var compconf = {};
	var $doc = $(document);

	$channelGlobal.on('share-to', function(rs){
		if(!rs || !rs.shareType){
			return;
		}
		var shareType = validShare.indexOf(rs.shareType) !== -1 ? rs.shareType : 'other';
		$bridge.request('openShare', {
			timeout : 200 * 1000,
			data : {
				action: "do_share",
				shareType: shareType,
			},
			callback : function(rs){
				// TODO
			},
			onTimeout : function(){}
		});
	});

	function initShareListen(){
		$doc.delegate(shareSelector, 'tap', function(e){
			var el = $(e.currentTarget);
			if(el.data('share-type')){
				$channelGlobal.trigger('share-to', {shareType: el.data('share-type')});
			}
		});
	}
	
	$htmlRender.ready(initShareListen);

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};

});
/**
 * @fileoverview 接受客户端下载的图片并展示
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/comp/loadRecommend', function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	var $channelApp = require('mods/channel/app');
	var $log = require('conf/static/log');
	var $tpl = require('lib/kit/util/template');
	var $mustache = require('vendor/mustache');
	var $bridge = require('mods/bridge/global');
	var $config = window.$CONFIG || {};
	var compconf = {
		maxCount: 30,
		pageCount: 5,
		preloadPage: 1,
		moduleName: 'recommends',
		selector:{
			moreBtn: '[click-type=loadmore-recommend]',
			listBox: '[data-role=recommendlist-box]',
			parentBox: '[data-pl=recommends]',
		},
		tagMap: {
			hdpic: '图集',
			subject: '专题',
			consice: '精读',
			audio: '有声',
			video: '视频',
			ad: '推广',
			sponsor: '广告',
			exclusive: '独家',
			blog: '博客',
			live: '直播',
			recommend: '推荐',
			plan: '策划',
			advertisement: '广告',
		},
		classMap: {
			sponsor: 'ads',
			advertisement: 'ads',
			ad: 'ads',
			video: 'video',
			other: 'txt',
		}
	};
	var _state = {};
	var $doc = $(document);
	var recommendListBox = null;
	var defaultImg = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAABCAYAAAD0In+KAAAACXBIWXMAACsQAAArEAFa08IJAAAKTWlDQ1BQaG90b3Nob3AgSUNDIHByb2ZpbGUAAHjanVN3WJP3Fj7f92UPVkLY8LGXbIEAIiOsCMgQWaIQkgBhhBASQMWFiApWFBURnEhVxILVCkidiOKgKLhnQYqIWotVXDjuH9yntX167+3t+9f7vOec5/zOec8PgBESJpHmomoAOVKFPDrYH49PSMTJvYACFUjgBCAQ5svCZwXFAADwA3l4fnSwP/wBr28AAgBw1S4kEsfh/4O6UCZXACCRAOAiEucLAZBSAMguVMgUAMgYALBTs2QKAJQAAGx5fEIiAKoNAOz0ST4FANipk9wXANiiHKkIAI0BAJkoRyQCQLsAYFWBUiwCwMIAoKxAIi4EwK4BgFm2MkcCgL0FAHaOWJAPQGAAgJlCLMwAIDgCAEMeE80DIEwDoDDSv+CpX3CFuEgBAMDLlc2XS9IzFLiV0Bp38vDg4iHiwmyxQmEXKRBmCeQinJebIxNI5wNMzgwAABr50cH+OD+Q5+bk4eZm52zv9MWi/mvwbyI+IfHf/ryMAgQAEE7P79pf5eXWA3DHAbB1v2upWwDaVgBo3/ldM9sJoFoK0Hr5i3k4/EAenqFQyDwdHAoLC+0lYqG9MOOLPv8z4W/gi372/EAe/tt68ABxmkCZrcCjg/1xYW52rlKO58sEQjFu9+cj/seFf/2OKdHiNLFcLBWK8ViJuFAiTcd5uVKRRCHJleIS6X8y8R+W/QmTdw0ArIZPwE62B7XLbMB+7gECiw5Y0nYAQH7zLYwaC5EAEGc0Mnn3AACTv/mPQCsBAM2XpOMAALzoGFyolBdMxggAAESggSqwQQcMwRSswA6cwR28wBcCYQZEQAwkwDwQQgbkgBwKoRiWQRlUwDrYBLWwAxqgEZrhELTBMTgN5+ASXIHrcBcGYBiewhi8hgkEQcgIE2EhOogRYo7YIs4IF5mOBCJhSDSSgKQg6YgUUSLFyHKkAqlCapFdSCPyLXIUOY1cQPqQ28ggMor8irxHMZSBslED1AJ1QLmoHxqKxqBz0XQ0D12AlqJr0Rq0Hj2AtqKn0UvodXQAfYqOY4DRMQ5mjNlhXIyHRWCJWBomxxZj5Vg1Vo81Yx1YN3YVG8CeYe8IJAKLgBPsCF6EEMJsgpCQR1hMWEOoJewjtBK6CFcJg4Qxwicik6hPtCV6EvnEeGI6sZBYRqwm7iEeIZ4lXicOE1+TSCQOyZLkTgohJZAySQtJa0jbSC2kU6Q+0hBpnEwm65Btyd7kCLKArCCXkbeQD5BPkvvJw+S3FDrFiOJMCaIkUqSUEko1ZT/lBKWfMkKZoKpRzame1AiqiDqfWkltoHZQL1OHqRM0dZolzZsWQ8ukLaPV0JppZ2n3aC/pdLoJ3YMeRZfQl9Jr6Afp5+mD9HcMDYYNg8dIYigZaxl7GacYtxkvmUymBdOXmchUMNcyG5lnmA+Yb1VYKvYqfBWRyhKVOpVWlX6V56pUVXNVP9V5qgtUq1UPq15WfaZGVbNQ46kJ1Bar1akdVbupNq7OUndSj1DPUV+jvl/9gvpjDbKGhUaghkijVGO3xhmNIRbGMmXxWELWclYD6yxrmE1iW7L57Ex2Bfsbdi97TFNDc6pmrGaRZp3mcc0BDsax4PA52ZxKziHODc57LQMtPy2x1mqtZq1+rTfaetq+2mLtcu0W7eva73VwnUCdLJ31Om0693UJuja6UbqFutt1z+o+02PreekJ9cr1Dund0Uf1bfSj9Rfq79bv0R83MDQINpAZbDE4Y/DMkGPoa5hpuNHwhOGoEctoupHEaKPRSaMnuCbuh2fjNXgXPmasbxxirDTeZdxrPGFiaTLbpMSkxeS+Kc2Ua5pmutG003TMzMgs3KzYrMnsjjnVnGueYb7ZvNv8jYWlRZzFSos2i8eW2pZ8ywWWTZb3rJhWPlZ5VvVW16xJ1lzrLOtt1ldsUBtXmwybOpvLtqitm63Edptt3xTiFI8p0in1U27aMez87ArsmuwG7Tn2YfYl9m32zx3MHBId1jt0O3xydHXMdmxwvOuk4TTDqcSpw+lXZxtnoXOd8zUXpkuQyxKXdpcXU22niqdun3rLleUa7rrStdP1o5u7m9yt2W3U3cw9xX2r+00umxvJXcM970H08PdY4nHM452nm6fC85DnL152Xlle+70eT7OcJp7WMG3I28Rb4L3Le2A6Pj1l+s7pAz7GPgKfep+Hvqa+It89viN+1n6Zfgf8nvs7+sv9j/i/4XnyFvFOBWABwQHlAb2BGoGzA2sDHwSZBKUHNQWNBbsGLww+FUIMCQ1ZH3KTb8AX8hv5YzPcZyya0RXKCJ0VWhv6MMwmTB7WEY6GzwjfEH5vpvlM6cy2CIjgR2yIuB9pGZkX+X0UKSoyqi7qUbRTdHF09yzWrORZ+2e9jvGPqYy5O9tqtnJ2Z6xqbFJsY+ybuIC4qriBeIf4RfGXEnQTJAntieTE2MQ9ieNzAudsmjOc5JpUlnRjruXcorkX5unOy553PFk1WZB8OIWYEpeyP+WDIEJQLxhP5aduTR0T8oSbhU9FvqKNolGxt7hKPJLmnVaV9jjdO31D+miGT0Z1xjMJT1IreZEZkrkj801WRNberM/ZcdktOZSclJyjUg1plrQr1zC3KLdPZisrkw3keeZtyhuTh8r35CP5c/PbFWyFTNGjtFKuUA4WTC+oK3hbGFt4uEi9SFrUM99m/ur5IwuCFny9kLBQuLCz2Lh4WfHgIr9FuxYji1MXdy4xXVK6ZHhp8NJ9y2jLspb9UOJYUlXyannc8o5Sg9KlpUMrglc0lamUycturvRauWMVYZVkVe9ql9VbVn8qF5VfrHCsqK74sEa45uJXTl/VfPV5bdra3kq3yu3rSOuk626s91m/r0q9akHV0IbwDa0b8Y3lG19tSt50oXpq9Y7NtM3KzQM1YTXtW8y2rNvyoTaj9nqdf13LVv2tq7e+2Sba1r/dd3vzDoMdFTve75TsvLUreFdrvUV99W7S7oLdjxpiG7q/5n7duEd3T8Wej3ulewf2Re/ranRvbNyvv7+yCW1SNo0eSDpw5ZuAb9qb7Zp3tXBaKg7CQeXBJ9+mfHvjUOihzsPcw83fmX+39QjrSHkr0jq/dawto22gPaG97+iMo50dXh1Hvrf/fu8x42N1xzWPV56gnSg98fnkgpPjp2Snnp1OPz3Umdx590z8mWtdUV29Z0PPnj8XdO5Mt1/3yfPe549d8Lxw9CL3Ytslt0utPa49R35w/eFIr1tv62X3y+1XPK509E3rO9Hv03/6asDVc9f41y5dn3m978bsG7duJt0cuCW69fh29u0XdwruTNxdeo94r/y+2v3qB/oP6n+0/rFlwG3g+GDAYM/DWQ/vDgmHnv6U/9OH4dJHzEfVI0YjjY+dHx8bDRq98mTOk+GnsqcTz8p+Vv9563Or59/94vtLz1j82PAL+YvPv655qfNy76uprzrHI8cfvM55PfGm/K3O233vuO+638e9H5ko/ED+UPPR+mPHp9BP9z7nfP78L/eE8/sl0p8zAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAAAXSURBVHjaYvz//z8DAwMDAwAAAP//AwAU/QL/l7P6GQAAAABJRU5ErkJggg==';
	var TPL = $tpl({
		item: [
			'<li ui-button>',
			'<a href="javascript:;"  ui-link="method:recommendClick;index:{{index}};url:url({{link}})">',
			'<dl>',
			'{{#imgLink}}<dt class="dt"><img src="{{localPic}}" data-src="{{imgLink}}" alt="{{title}}">{{/imgLink}}</dt>',
			'<dd class="dd">',
			'<p class="title">{{title}}</p>',
			'<p class="option">',
			'{{#tag}}<span class="{{tagClass}}">{{tag}}</span>{{/tag}}',
			'{{#notAd}}<span class="comment">{{comment}}</span>{{/notAd}}',
			'</p>',
			'</dd></dl></a>',
			'</li>',
		],
	});
	var itemTpl = TPL.get('item');
	function renderRecommendItem(datas, start){
		var morePics = [];
		var tpl = TPL.get('item');
		var i=0;
		var html = datas.map(function(data){
			if(data.title && data.link){
				data.imgLink = data.imgID || data.kpic;
				// data.kpic && (data.orgPic=data.kpic);
				// data.kpic =  || data.kpic;
				data.imgLink && morePics.push(data.imgLink);
				!data.localPic && (data.localPic=defaultImg);
				data.index == null && (data.index = start + (i++));
				//data.category=='video' && (data.isVideo=true);
				compconf.tagMap.hasOwnProperty(data.category) && (data.tag=compconf.tagMap[data.category]);
				data.tagClass = compconf.classMap[data.category] || compconf.classMap['other'];
				data.notAd = data.tagClass !== 'ads';
				return $mustache.render(tpl, data);
			}
			i++;
			return '';
		}).join('');
		return [html, morePics];
	}
	function addMoreListen(){
		$doc.delegate(compconf.selector.moreBtn, 'tap', function(e){
			if(_state.more){

				_state.loading = true;
				var moreData = _state.newsQueue.slice(_state.start, (_state.start+compconf.pageCount));
				var ret = renderRecommendItem(moreData, _state.start);
				_state.start+=compconf.pageCount;
				recommendListBox.append(ret[0]);

				_state.more = _state.start < _state.total;
				!_state.more && $(compconf.selector.moreBtn).hide();
				_state.loading = false;

				ret[1].length && $bridge.request('loadImgs', {
					data : {
						target : ret[1],
					}
				});
				$bridge.request('recommendLoadMore', {
					data: {
						//pageSize : _state.more?compconf.pageCount:(_state.start-_state.total+compconf.pageCount),
						pageSize : compconf.pageCount,
						pageNum : _state.start / compconf.pageCount,
						//target: _state.start / compconf.pageCount //5.2以前使用
					}
				});
			}
		});
	}
	function initExposeEvent(){
		var exposed = false;
		var winHeight = window.innerHeight;
		$(window).on('scroll', function(){
				if(!exposed && recommendListBox.length){
					var pos = recommendListBox[0].getBoundingClientRect();
					if(typeof(pos.top) === 'number' && pos.top >0 && pos.top < winHeight){
						exposed = true;
						$bridge.request('recommendExpose', {
							data:{
								//pageSize : _state.more?compconf.pageCount:(_state.start-_state.total+compconf.pageCount),
								pageSize : compconf.pageCount,
								pageNum : 1
							}
						});
					}
				}
		});
	}
	//5.1.1
	//function buildRecommendLoader(){
	//5.2
	function buildRecommendLoader(recommendData){
		//5.1.1
		// var pageData = $config.pageData;
		// var recommendData = null;
		// if(pageData && $.type(pageData.data) === 'array'){
		// 	pageData.data.forEach(function(item){
		// 		if(item && item.type === compconf.moduleName){
		// 			recommendData = item.data;
		// 			console.log("test:"+recommendData);
		// 		}
		// 	});
		// }
		//5.1.1
		//debugger
		recommendListBox = $(compconf.selector.listBox);
		if(recommendListBox && recommendData && $.type(recommendData) === 'array'){
			//debugger
			_state.newsQueue = recommendData;
			_state.total = recommendData.length;
			_state.start = compconf.preloadPage * compconf.pageCount;
			_state.more = _state.start < _state.total;
			_state.loading = false;
			//build firt page
			var ret = renderRecommendItem(recommendData.slice(0, _state.start), 0);
			recommendListBox.html(ret[0]);
			//debugger;
			ret[1].length && $bridge.request('loadImgs', {
				data : {
					target : ret[1],
				}
			});
			//listen more
			!_state.more && $(compconf.selector.moreBtn).hide();
			//$(compconf.selector.parentBox).show();
			_state.more && addMoreListen();
			initExposeEvent();
		}else{
			if(recommendListBox && recommendListBox.length > 0){
				recommendListBox.hide();
			}
		}
	}
	// }
	
	module.exports = {
		init : function(options){
			$.extend(compconf, options);
			$htmlRender.ready(function(){
				//5.1.1
				//buildRecommendLoader();
				//5.1.1
				//5.2
				$channelApp.on('content-load-success', function(rs){
					//debugger
					if(rs && rs.data.type === compconf.moduleName){
						//window.log(compconf.moduleName,JSON.stringify(rs));
						buildRecommendLoader(rs.data.data);
					}
				});
				//5.2
			});
			//$htmlRender.ready(buildRecommendLoader);
		}
	};
});
/**
 * @fileoverview 正文围观组件
 * @authors yuanfeng <yuanfeng@staff.sina.com.cn>
 */

define('mods/comp/iSupport',function(require,exports,module){

	var $ = require('lib');
	var $htmlRender = require('lib/common/htmlRender');
	//var $channelGlobal = require('mods/channel/global');
	var $mustache = require('vendor/mustache');
	var $channelApp = require('mods/channel/app');
	var $bridge = require('mods/bridge/global');
	//var $config = window.$CONFIG || {};

	var wrapperSelector = '[data-pl="iSupport"]';
	var roles = {
		templateNode: 'templateBox',
		buttonNode: 'actionButton',
		animateAreaNode: 'animateArea',
		totalCountNode: 'totalCount',
		signCountNode: 'selfCount',
		signBoxNode: 'signBox',
	};
	var iCareAdExist = false;
	//var validShare = ['qq', 'weixin', 'weibo', 'friends'];
	//var shareSelector = '[click-type="goto-share"]';
	var compconf = {
		moduleName: 'iSupport',
	};
	//var $doc = $(document);
  
	function extend(src, target, cover){
    cover = cover || false;
    for(var i in target){
        target.hasOwnProperty(i) && !src.hasOwnProperty(i) || cover ? src[i]=target[i] : '';
    }
  }

	var EventFactory = function(){
	  var eventMap = {};
	  function initEvent(live){
	    return {
	      listener: [], // {func: Function, liveIndex: 0}
	      isLive: live || false,
	      liveEvents: [],
	    };
	    }
	  function addListener(eventObj, listenFunc){
	    var listenerProxy = eventObj.listener,
	      exist = false,
	      listenObj = {};
	    exist = !listenerProxy.every(function(tmp){
	      if(tmp.func !== listenFunc){
	        return true;
	      }else{
	        listenObj = tmp;
	        return false;
	      }
	    });
	    if(!exist){
	      listenObj = {
	        func: listenFunc,
	        liveIndex: 0,
	      };
	      listenerProxy.push(listenObj);
	    }
	    return listenObj;
	  }
	  return {
	    on: function(eventName, func, isLive){
	      if(!this.eventMap){
	        this.eventMap = {};
	      }
	      eventMap = this.eventMap;
	      var eventObj=null, listenerObj=null, isLive=isLive||false;
	      if(!eventMap.hasOwnProperty(eventName)){
	        eventMap[eventName] = initEvent(isLive);
	      }
	      eventObj = eventMap[eventName];
	      listenObj = addListener(eventMap[eventName], func);
	      if(isLive && eventObj.liveEvents.length > 0 && listenObj.liveIndex < eventObj.liveEvents.length){
	        listenObj.liveIndex = eventObj.liveEvents.length;
	        var i=listenObj.liveIndex,
	          len = eventObj.liveEvents.length;
	        eventObj.liveIndex = len;
	        for(;i<len;i++){
	          eventObj.func.apply(window, eventObj.liveEvents[i]);
	        }
	      }
	    },
	    trigger: function(eventName, params, isLive){
	      //isLive = typeof(isLive) === 'boolean' ? isLive : true;
	      var eventObj = {};
	      if(!this.eventMap){
	        this.eventMap = {};
	      }
	      eventMap = this.eventMap; 
	      if(!eventMap.hasOwnProperty(eventName)){
	        eventObj = eventMap[eventName] = initEvent(typeof(isLive) === 'boolean' ? isLive : true);
	        eventObj.liveEvents.push(params);
	      }else{
	        eventObj = eventMap[eventName];
	        eventObj.listener.forEach(function(listenObj){
	          try{
	            listenObj.func.apply(window, params);
	          }catch(err){
	            console.error && console.error(err);
	          }
	        });
	        isLive ? eventObj.liveEvents.push(params) : '';
	      }
	    }
	  };
	}

  var workerPoolFactory = function(cnf){
  	this._construct(cnf);
	};
	workerPoolFactory.prototype = {
    _construct: function(cnf){
	    if(!cnf.workerTemplate || !cnf.workerArea){
	      throw new Error('missing worker template or worker area!');
	    }
      this._cnf = {
			    workerArea: cnf.workerArea,
			    workerTemplate: cnf.workerTemplate,
			    workeTime: 1000,
			    maxLen: cnf.maxWorker || 10,
			    minLen: cnf.minWorker || 5,
			    AliveTime: cnf.workerAliveTime || 15 * 60 * 1000
			};
    },
    _buildWorker: function(){
			var self = this;
			var cnf = this._cnf;
			var node = cnf.workerTemplate.cloneNode();
			(node.children.length === 0) && ([].forEach.call(cnf.workerTemplate.children,function(elems){
				node.appendChild(elems.cloneNode());
			}));
			var workIns = {
			    endTime: 0,
			    working: false,
			    stat: {
			    	curAnimate: null,
			    	startPos: [0, 0]
			    },
			    node: $(node),
			    run: function(set){
		        var nowTime = Date.now();
		        var curIns = this;
	          // ToDo add action
	          // debugger
	          this.endTime = nowTime + (set.workeTime || cnf.workeTime);
	          this.node.removeClass('hide');
	          this.stat.curAnimate && this.node.removeClass(this.stat.curAnimate);
	          this.node.addClass(set.animateType);
	          //console.log(set.animateType)
	          this.node.css({top: set.pos[0], left: set.pos[1]});
	          this.stat.curAnimate = set.animateType;
			    },
			    stop: function(){
			    	this.working = false;
	          this.endTime = 0;
			      //this.node.addClass('hide');
			    }
			};
			workIns.node.addClass('hide');
			cnf.workerArea.append(workIns.node);
			return workIns;
    },
    requireWorker: function(){
			var wq = this.workerQueue;
			var ret = null;
			//console.log('busy'+wq.busy)
			var nowTime = Date.now();
			(wq.busy > 0) && wq.all.forEach(function(worker, index){
				if(worker.working && worker.endTime <= nowTime){
				    worker.stop();
				    wq.busy --;
				    wq.wait.push(index);
				}
		  });
		  if(wq.wait.length > 0){
				wq.busy ++;
		    ret = wq.all[wq.wait.shift()];
				ret.working = true;
		  }
			if(ret === null &&  wq.len < this._cnf.maxLen){
			    var ret = this._buildWorker();
			    ret.working = true;
			    wq.busy ++;
			    wq.len ++;
			    ret.id = wq.all.push(ret) - 1;
			}
			return ret;
    },
    releaseWorker: function(worker){
			var wq = this.workerQueue;
      if(worker){
		    ret.working = false;
		    wq.busy --;
		    worker.stop();
		    wq.wait.push(ret.id);
			}
    },
    get workerQueue(){
			return this._workerQueue || (this._workerQueue = {
				len: 0, 
				busy: 0, 
				wait: [], // item is number 
				all: [] // item is dict
			});
		},
		set workerQueue(val){
		  return null;	
		},
	};

	var iSupportExpress = {
    _type: function(obj){
			var ret = typeof(obj);
			return ret  !== 'object' ? ret : Object.prototype.toString.call(obj).match(/\[object ([a-zA-z]+)\]/)[1].toLowerCase();
    },
    _getRandom: function(max){
      return parseInt(Math.random()*5);
    },
    get cnf(){
      return this._cnf || (this.cnf=null);
    },
    set cnf(val){
			if(!this._cnf){
			  this._cnf = {
			  	animateEnable: true,
			  	gAnimateType: 'long',
			  	shortJudge: 100,
					animateModels: {
						short: {
							time: 4,
							models: ['a_c_s','a_l_s_1','a_l_s_2','a_r_s_1','a_r_s_2'],
						},
						long: {
							time: 4,
							models: ['a_c_l','a_l_l_1','a_l_l_2','a_r_l_1','a_r_l_2'],
						},
					},
          buttonAction: ['a_big', '', 'a_small'],
          pressDelay: 1000, //ms
          signHideDelay: 1000, //ms
          validArea: {
            //ceil: [8, 30],
            //row: [15, 25]
            ceil: [0, 0],
            row: [0, 0]
          },
			  };
			}
			if(this._type(val) === 'object'){
		    Object.keys(val).forEach(function(key){
		      this._cnf[key] = val[key];
		    });
			}
			return this._cnf;
    },
    init: function(cnf){
    	var self = this;
      cnf.expressCnf && (this.cnf = cnf.expressCnf);
      this.cnf.animateEnable && (this.workers = new workerPoolFactory(cnf.workerCnf || {}));
      this._stat = {
        hideSignTimer: null,
        signState: 0,
        pressOutTimer: null,
        pressState: 0,
        curCount: cnf.curCount,
        totalCount: cnf.totalCount
      };
      this._elems = {
        button: cnf.elems.buttonNode,
        signBox: cnf.elems.signBoxNode,
        signCount: cnf.elems.signCountNode,
        totalCount: cnf.elems.totalCountNode,
        animateArea: cnf.elems.animateAreaNode,
        wrappBox: cnf.elems.wrappBoxNode, 
      };
      this.addEvent();
    },
    convNum: function(num){
    	return num > 9999 ? parseInt(num / 10000) + '万' : num;
    },
    addCount: function(count){
      var stat = this._stat;
      var elems = this._elems;
      var cnf = this.cnf;
      if(!stat.signState){
        stat.signState = 1;
        elems.signBox.show();
      }
      stat.hideSignTimer && clearTimeout(stat.hideSignTimer);
      stat.hideSignTimer = setTimeout(function(){
        stat.signState = 0;
        elems.signBox.hide();
      }, cnf.signHideDelay);
      
      stat.curCount ++;
      elems.signCount.text(this.convNum(stat.curCount));
      stat.totalCount ++;
      elems.totalCount.text(this.convNum(stat.totalCount));

      this.trigger('addCount', ['express_addcount']);
      // fire count add
    },
    setButtonAction: function(){
    	var stat = this._stat;
    	var elems = this._elems;
    	var cnf = this.cnf;
    	if(!stat.pressState){
    		//elems.button.removeClass(cnf.buttonAction[1]);
    		elems.button.removeClass(cnf.buttonAction[2]);
    		elems.button.addClass(cnf.buttonAction[0]);
    	}
    	stat.pressOutTimer && clearTimeout(stat.pressOutTimer);
    	stat.pressOutTimer = setTimeout(function(){
				//elems.button.addClass(cnf.buttonAction[1]);
				elems.button.removeClass(cnf.buttonAction[0]);
				elems.button.addClass(cnf.buttonAction[2]);
				//setTimeout(function(){elems.button.addClass(cnf.buttonAction[2])},200);
  		}, cnf.pressDelay);
    },
    addAnimate: function(mType){
    	// debugger
    	var cnf = this.cnf;
    	var animateModel = cnf.animateModels[mType];
    	var animateModelSets = animateModel.models;
    	var animateModelLen = animateModelSets.length;
      var randomSeed = this._getRandom(animateModelLen);
      var curWorker = this.workers.requireWorker();
      var tmp, animateType;
      if(curWorker){
      	if((tmp=animateModelSets.indexOf(curWorker.stat.curAnimate)) !== -1){
      		animateType = animateModel.models[(tmp + 1) % animateModelLen];
      	}else{
      		animateType = animateModel.models[randomSeed % animateModelLen];
      	}
      	var randomRate = randomSeed / animateModelLen;
      	// console.log(animateType)
      	curWorker.run({
      		animateType: animateType,
      		pos: [
      			cnf.validArea.ceil[0] + cnf.validArea.ceil[1]*randomRate%cnf.validArea.ceil[1],
      			cnf.validArea.row[0] + cnf.validArea.row[1]*randomRate%cnf.validArea.row[1],
      		],
      		workeTime: animateModel.time*1000,
      	});
      }
    },
    addEvent: function(){
      var cnf = this.cnf;
      var elems = this._elems;
      var self = this;
      elems.button.on('tap', function(){
      	//self.setButtonAction();
        cnf.animateEnable  && self.addAnimate(cnf.gAnimateType);
        self.addCount();
      });
      if(elems.wrappBox.getBoundingClientRect){
      	this.on('pageResize', function(src){
      		posInfo = elems.wrappBox.getBoundingClientRect();
      		cnf.gAnimateType = (self._type(posInfo.top) === 'number' && posInfo.top > cnf.shortJudge) ? 'long' : 'short';
	      });
	      this.on('pageScroll', function(src){
      		posInfo = elems.wrappBox.getBoundingClientRect();
      		cnf.gAnimateType = (self._type(posInfo.top) === 'number' && posInfo.top > cnf.shortJudge) ? 'long' : 'short';
	      });
      }
    }
	}

	extend(iSupportExpress, EventFactory());

	function initISupport(iSupportData){
		// var pageData = $config.pageData;
		// var iSupportData = null;
		// pageData.data.forEach(function(item){
		// 	if(item && item.type === compconf.moduleName){
		// 		iSupportData = item.data;
		// 	}
		// });
		//debugger
		try{
			!iSupportData && window.$CONFIG.pageData.data.forEach(function(item){
				if(item && item.type === compconf.moduleName){
					iSupportData = item.data;
				}
			});
		}catch(err){
			console.log(err);
		}
		
		if(!iSupportData){
			return;
		}
		var wrapperRoot = $(wrapperSelector);
		var roleNodes = {};
		Object.keys(roles).forEach(function(roleName){
			roleNodes[roleName] = wrapperRoot.find('[data-role="'+roles[roleName]+'"]');
		});
		roleNodes['wrappBoxNode'] = wrapperRoot[0];
		showParent(wrapperSelector);
		!iCareAdExist && changeCurrent(wrapperSelector,true);

		//debugger
		iSupportExpress.init({
			workerCnf: {
				workerArea: roleNodes.animateAreaNode,
				workerTemplate: roleNodes.templateNode.children()[0],
				maxWorker: 20,
			},
			expressCnf: {
			},
			totalCount: iSupportData.total || 0,
			curCount: iSupportData.current || 0,
			elems: roleNodes,
		});

		iSupportExpress.on('addCount', function(){
			var data = {
				action: 'do_isupport',
			};
			$bridge.request('requestCallback', {
				timeout : 90 * 1000,
				data : data,
				callback : function(rs){
				},
				onTimeout : function(){
				}
			});
			//console.log('addCount');
		});
	}

	var iCareAd = {
		tpl : '[data-pl="iCareAd"]',
		modueName : 'iCareAd',
		roles : {adNode: 'adBox',},
		roleNodes : {},
		getTPL : function(){
			var mName = this.modueName,
					_TPL = $('[name="'+mName+'"]');

			if(_TPL.length>0 && _TPL.html()){
				return _TPL.html();
			}else{
				return null;
			}
		},
		addListener : function(){
			var roleNodes = {},
					_roles = this.roles,
					_tpl = this.tpl,
					wrapperRoot = $(_tpl);

			Object.keys(_roles).forEach(function(roleName){
				roleNodes[roleName] = wrapperRoot.find('[data-role="'+_roles[roleName]+'"]');
			});

			for(var o in roleNodes){
				//debugger
				roleNodes[o] && roleNodes[o].on('tap', function(){
					changeCurrent(_tpl,false);
				});
			}
			
		},
		init : function(iCareAdData){
			// try{
			// 	!iCareAdData && window.$CONFIG.pageData.data.forEach(function(item){
			// 		if(item && item.type === this.iCareAd.moduleName){
			// 			iCareAdData = item.data;
			// 		}
			// 	});
			// }catch(err){
			// 	console.log(err);
			// }

			// if(!iCareAdData){
			// 	return;
			// }

			// var _tpl = this.getTPL(),
			// 	item = {type:this.modueName,data:iCareAdData.data},
			// 	targetNode = $(this.tpl),
			// 	html = $mustache.render(_tpl, iCareAdData);
			
			//targetNode && targetNode.replaceWith($(html));
			//$htmlRender.renderItem(item);
			this.addListener();
			showParent(this.tpl);
			changeCurrent(this.tpl,true);
			iCareAdExist = true;
		}
	};

	function showParent(ele){
		var wrapperRoot = $(ele);
		var wrapperParent = wrapperRoot.parent('li');
		if(wrapperParent.css('display')=='none'){
				wrapperParent.css('display','block');
		}
	}	

	function changeCurrent(ele,isShow){
		var parentWrap = $(ele).parent(),
				childrenWrap = parentWrap.children() || [],
				curWrap = $(ele);

		Array.prototype.slice.call(childrenWrap).forEach(function(item){
			isShow && $(item).addClass('hide');
			!isShow && $(item).removeClass('hide');
		})
		isShow && $(ele).removeClass('hide');
		!isShow && $(ele).addClass('hide');

	}

	$htmlRender.ready(function(){
		$channelApp.on('content-load-success', function(rs){
			if(rs && rs.data.type === 'iSupport'){
				initISupport(rs.data.data);
			}
		});
	});

	$htmlRender.ready(function(){
		$channelApp.on('content-load-success', function(rs){
			if(rs && rs.data.type === 'iCareAd'){
				iCareAd.init(rs.data);
			}
		});		
	});

	module.exports = {
		init : function(options){
			$.extend(compconf, options);
		}
	};
});

/**
 * @fileoverview 客户端通信对象
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */
define('mods/bridge/global',function(require,exports,module){

	var $jsbridge = require('lib/common/jsbridge');

	module.exports = new $jsbridge([
		//html渲染完成
		'htmlReady',
		//要求重新下载图片
		'loadImg',
		//要求播放视频
		'playVideo',
		//获取视频页面位置
		'getVideoOffset',
		//播放直播视频
		'playLiveVideo',
		//点击了直播链接
		'liveClick',
		//点击了单张图片
		'imgClick',
		//点击普通图集
		'imgsClick',
		//点击高清图集
		'hdImgsClick',
		//点击了微博
		'weiboClick',
		//点击了微博转发
		'weiboRepost',
		//点击了微博评论
		'weiboComment',
		//点击了微博组中的转发
		'weiboGroupRepost',
		//点击了微博组中的评论
		'weiboGroupComment',
		//点击了关键字
		'keywordClick',
		//点击了文字广告
		'adTextClick',
		//点击了图片广告
		'adBannerClick',
		//点击了app推广
		'appExtClick',
		//点击了相关新闻
		'recommendClick',
		//点击了热门评论
		'hotCommentClick',
		//点击了深度解读
		'deepReadClick',
		//点击了横滑组图的一张图片
		'imageGroupClick',
		//点击了横滑组图的一张图片，高清
		'hdImageGroupClick',
		//评论喜欢
		'comment_like',
		//评论回复
		'comment_reply',
		//点击了查看原网页
		'webpageClick',
		//发送接口请求
		'request',
		//发送客户端本地请求
		'requestCallback',
		//gif图优化gif进入屏幕
		'gifEnterScreen',
		//gif图优化gif离开屏幕
		'gifLeaveScreen',
		//延迟加载的内容html渲染完毕
		'loadContentSuccess',
		//评论举报
		'comment_report',
		//顶踩评论转发到微博
		'diggerSendWeibo',
		//点击小编提问唤起评论框
		'openComment',
		//打log
		'log',
		//唤起客户端的分享
		'openShare',
		//加载多张图
		'loadImgs',
		//相关新闻加载下一页
		'recommendLoadMore',
		//相关新闻曝光
		'recommendExpose',
		//点赞广告
		'careAdClick'
	]);

});

/**
 * @fileoverview 解析自定义属性值为一个对象，或者将一个hash对象解析为一个自定义属性值，以类似CSS的键值对方式。 
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 * @example
	var $propQuery = require('lib/kit/util/propQuery');

	//output 'a:1;b:2;c:3;'
	$propQuery.stringify({a:1, b:2, c:3});

	//output {a:'1', b:'2', c:'3'}
	$propQuery.parse('a:1;b:2;c:3');

	//output {a:'1',b:'http:path;extra'}
	$propQuery.parse('a:1;b:url(http:path;extra);c:;s$a#:adf;');
 */

define('lib/kit/util/propQuery',function(require,exports,module){

	var $ = require('lib');

	var propQuery = {};

	propQuery.parse = function(str){
		var obj = {};
		str = str || '';
		str = str + '';
		str = str.trim();
		//确保字符串末尾以分号结束
		if(str.charAt(str.length - 1) !== ';'){
			str = str + ';';
		}
		str.replace(/\s*(\w+)\s*\:\s*url\(([^\)]*)\)\s*\;/gi, function(p, key, val){
			//匹配key:url(http://path;extra);的情况
			//解析为key:'http://path;extra'
			obj[key] = val.trim();
			return '';
		}).replace(/\s*(\w+)\s*\:\s*([^;]+)\s*\;/gi, function(p, key, val){
			//匹配key:value;的情况
			//解析为key:'val'
			obj[key] = val.trim();
			return '';
		});
		return obj;
	};

	propQuery.stringify = function(object){
		var str = '';
		if($.isPlainObject(object)){
			str = Object.keys(object).map(function(key){
				return key + ':' + object[key] + ';';
			}).join('');
		}else{
			str = str + object;
		}
		return str;
	};

	module.exports = propQuery;

});


/**
 * @fileoverview 与客户端交互的广播
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/channel/app',function(require,exports,module){

	var $ = require('lib');
	var $listener = require('lib/common/listener');
	var $bridge = require('mods/bridge/global');

	var clientEventList = [
		//切换白天夜间模式
		'switch-daynight',
		//字体字号发生变更
		'font-change',
		//图片加载完成
		'img-load',
		//页面失去焦点
		'page-blur',
		//延迟插入后续内容
		'content-insert',
		//延迟替换后续内容
		'content-load',
		//两手指向外滑动文字放大，视频全屏播放返回,两手指向内滑动文字放小，视频位置展示bug修复
		'update-video-postion',
		//延迟加载内容渲染成功消息发送
		'content-load-success',
		//顶踩发布到微博和全部评论同步状态
		'digger-weibo-status-synch',
        //调试专用
        'call-console'
	];

	var appListener = new $listener();

	appListener.register = function(localEvent, clientEvent){
		if(!localEvent){return;}
		if(!clientEvent){
			clientEvent = localEvent;
		}
		appListener.define(localEvent);
		$bridge.request('addEventListener', {
			event : clientEvent,
			callback : 'try{window.listener.trigger("' + localEvent + '",[data]);}catch(e){}'
		});
	};

	clientEventList.forEach(function(name){
		appListener.register(name);
	});

	window.listener = appListener;

	module.exports = appListener;

});

/**
 * @fileoverview iScroll模拟滚动条 
 * @authors xiaoyue3 <xiaoyue3@staff.sina.com.cn>
 */

define('vendor/iscroll5',function(require,exports,module){

/*! iScroll v5.1.3 ~ (c) 2008-2014 Matteo Spinelli ~ http://cubiq.org/license */
(function (window, document, Math) {

var rAF = window.requestAnimationFrame	||
	window.webkitRequestAnimationFrame	||
	window.mozRequestAnimationFrame		||
	window.oRequestAnimationFrame		||
	window.msRequestAnimationFrame		||
	function (callback) { window.setTimeout(callback, 1000 / 60); };

var cancelRAF = window.cancelRequestAnimationFrame ||
			window.webkitCancelAnimationFrame ||
			window.webkitCancelRequestAnimationFrame ||
			window.mozCancelRequestAnimationFrame ||
			window.oCancelRequestAnimationFrame ||
			window.msCancelRequestAnimationFrame ||
			clearTimeout;

var utils = (function () {
	var me = {};

	var _elementStyle = document.createElement('div').style;
	var _vendor = (function () {
		var vendors = ['t', 'webkitT', 'MozT', 'msT', 'OT'],
			transform,
			i = 0,
			l = vendors.length;

		for ( ; i < l; i++ ) {
			transform = vendors[i] + 'ransform';
			if ( transform in _elementStyle ){
				return vendors[i].substr(0, vendors[i].length-1);
			} 
		}
		return false;
	})();

	function _prefixStyle (style) {
		if ( _vendor === false ) return false;
		if ( _vendor === '' ) return style;
		return _vendor + style.charAt(0).toUpperCase() + style.substr(1);
	}

	me.getTime = Date.now || function getTime () { return new Date().getTime(); };

	me.extend = function (target, obj) {
		for ( var i in obj ) {
			target[i] = obj[i];
		}
	};

	me.addEvent = function (el, type, fn, capture) {
		el.addEventListener(type, fn, !!capture);
	};

	me.removeEvent = function (el, type, fn, capture) {
		el.removeEventListener(type, fn, !!capture);
	};

	me.prefixPointerEvent = function (pointerEvent) {
		return window.MSPointerEvent ? 
			'MSPointer' + pointerEvent.charAt(9).toUpperCase() + pointerEvent.substr(10):
			pointerEvent;
	};

	me.momentum = function (current, start, time, lowerMargin, wrapperSize, deceleration) {
		var distance = current - start,
			speed = Math.abs(distance) / time,
			destination,
			duration;

		deceleration = deceleration === undefined ? 0.0006 : deceleration;

		destination = current + ( speed * speed ) / ( 2 * deceleration ) * ( distance < 0 ? -1 : 1 );
		duration = speed / deceleration;

		if ( destination < lowerMargin ) {
			destination = wrapperSize ? lowerMargin - ( wrapperSize / 2.5 * ( speed / 8 ) ) : lowerMargin;
			distance = Math.abs(destination - current);
			duration = distance / speed;
		} else if ( destination > 0 ) {
			destination = wrapperSize ? wrapperSize / 2.5 * ( speed / 8 ) : 0;
			distance = Math.abs(current) + destination;
			duration = distance / speed;
		}

		return {
			destination: Math.round(destination),
			duration: duration
		};
	};

	var _transform = _prefixStyle('transform');

	me.extend(me, {
		hasTransform: _transform !== false,
		hasPerspective: _prefixStyle('perspective') in _elementStyle,
		hasTouch: 'ontouchstart' in window,
		hasPointer: window.PointerEvent || window.MSPointerEvent, // IE10 is prefixed
		hasTransition: _prefixStyle('transition') in _elementStyle
	});

	// This should find all Android browsers lower than build 535.19 (both stock browser and webview)
	me.isBadAndroid = /Android /.test(window.navigator.appVersion) && !(/Chrome\/\d/.test(window.navigator.appVersion));

	me.extend(me.style = {}, {
		transform: _transform,
		transitionTimingFunction: _prefixStyle('transitionTimingFunction'),
		transitionDuration: _prefixStyle('transitionDuration'),
		transitionDelay: _prefixStyle('transitionDelay'),
		transformOrigin: _prefixStyle('transformOrigin')
	});

	me.hasClass = function (e, c) {
		var re = new RegExp("(^|\\s)" + c + "(\\s|$)");
		return re.test(e.className);
	};

	me.addClass = function (e, c) {
		if ( me.hasClass(e, c) ) {
			return;
		}

		var newclass = e.className.split(' ');
		newclass.push(c);
		e.className = newclass.join(' ');
	};

	me.removeClass = function (e, c) {
		if ( !me.hasClass(e, c) ) {
			return;
		}

		var re = new RegExp("(^|\\s)" + c + "(\\s|$)", 'g');
		e.className = e.className.replace(re, ' ');
	};

	me.offset = function (el) {
		var left = -el.offsetLeft,
			top = -el.offsetTop;

		// jshint -W084
		while (el = el.offsetParent) {
			left -= el.offsetLeft;
			top -= el.offsetTop;
		}
		// jshint +W084

		return {
			left: left,
			top: top
		};
	};

	me.preventDefaultException = function (el, exceptions) {
		for ( var i in exceptions ) {
			if ( exceptions[i].test(el[i]) ) {
				return true;
			}
		}

		return false;
	};

	me.extend(me.eventType = {}, {
		touchstart: 1,
		touchmove: 1,
		touchend: 1,

		mousedown: 2,
		mousemove: 2,
		mouseup: 2,

		pointerdown: 3,
		pointermove: 3,
		pointerup: 3,

		MSPointerDown: 3,
		MSPointerMove: 3,
		MSPointerUp: 3
	});

	me.extend(me.ease = {}, {
		quadratic: {
			style: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)',
			fn: function (k) {
				return k * ( 2 - k );
			}
		},
		circular: {
			style: 'cubic-bezier(0.1, 0.57, 0.1, 1)',	// Not properly "circular" but this looks better, it should be (0.075, 0.82, 0.165, 1)
			fn: function (k) {
				return Math.sqrt( 1 - ( --k * k ) );
			}
		},
		back: {
			style: 'cubic-bezier(0.175, 0.885, 0.32, 1.275)',
			fn: function (k) {
				var b = 4;
				return ( k = k - 1 ) * k * ( ( b + 1 ) * k + b ) + 1;
			}
		},
		bounce: {
			style: '',
			fn: function (k) {
				if ( ( k /= 1 ) < ( 1 / 2.75 ) ) {
					return 7.5625 * k * k;
				} else if ( k < ( 2 / 2.75 ) ) {
					return 7.5625 * ( k -= ( 1.5 / 2.75 ) ) * k + 0.75;
				} else if ( k < ( 2.5 / 2.75 ) ) {
					return 7.5625 * ( k -= ( 2.25 / 2.75 ) ) * k + 0.9375;
				} else {
					return 7.5625 * ( k -= ( 2.625 / 2.75 ) ) * k + 0.984375;
				}
			}
		},
		elastic: {
			style: '',
			fn: function (k) {
				var f = 0.22,
					e = 0.4;

				if ( k === 0 ) { return 0; }
				if ( k == 1 ) { return 1; }

				return ( e * Math.pow( 2, - 10 * k ) * Math.sin( ( k - f / 4 ) * ( 2 * Math.PI ) / f ) + 1 );
			}
		}
	});

	me.tap = function (e, eventName) {
		var ev = document.createEvent('Event');
		ev.initEvent(eventName, true, true);
		ev.pageX = e.pageX;
		ev.pageY = e.pageY;
		e.target.dispatchEvent(ev);
	};

	me.click = function (e) {
		var target = e.target,
			ev;

		if ( !(/(SELECT|INPUT|TEXTAREA)/i).test(target.tagName) ) {
			ev = document.createEvent('MouseEvents');
			ev.initMouseEvent('click', true, true, e.view, 1,
				target.screenX, target.screenY, target.clientX, target.clientY,
				e.ctrlKey, e.altKey, e.shiftKey, e.metaKey,
				0, null);

			ev._constructed = true;
			target.dispatchEvent(ev);
		}
	};

	return me;
})();

function IScroll (el, options) {
	this.wrapper = typeof el == 'string' ? document.querySelector(el) : el;
	this.scroller = this.wrapper.children[0];
	this.scrollerStyle = this.scroller.style;		// cache style for better performance

	this.options = {

		resizeScrollbars: true,

		mouseWheelSpeed: 20,

		snapThreshold: 0.334,

// INSERT POINT: OPTIONS 

		startX: 0,
		startY: 0,
		scrollY: true,
		directionLockThreshold: 5,
		momentum: true,

		bounce: true,
		bounceTime: 600,
		bounceEasing: '',

		preventDefault: true,
		preventDefaultException: { tagName: /^(INPUT|TEXTAREA|BUTTON|SELECT)$/ },

		HWCompositing: true,
		useTransition: true,
		useTransform: true,
		//@modified xiaoyue3 15-06-17
		//新增参数 进度条边框透明度根据是否是夜间模式要调整
		scrollBarOpacity : 0.9
	};

	for ( var i in options ) {
		this.options[i] = options[i];
	}
	
	// Normalize options
	this.translateZ = this.options.HWCompositing && utils.hasPerspective ? ' translateZ(0)' : '';

	this.options.useTransition = utils.hasTransition && this.options.useTransition;
	this.options.useTransform = utils.hasTransform && this.options.useTransform;

	this.options.eventPassthrough = this.options.eventPassthrough === true ? 'vertical' : this.options.eventPassthrough;
	this.options.preventDefault = !this.options.eventPassthrough && this.options.preventDefault;

	// If you want eventPassthrough I have to lock one of the axes
	this.options.scrollY = this.options.eventPassthrough == 'vertical' ? false : this.options.scrollY;
	this.options.scrollX = this.options.eventPassthrough == 'horizontal' ? false : this.options.scrollX;

	// With eventPassthrough we also need lockDirection mechanism
	this.options.freeScroll = this.options.freeScroll && !this.options.eventPassthrough;
	this.options.directionLockThreshold = this.options.eventPassthrough ? 0 : this.options.directionLockThreshold;

	this.options.bounceEasing = typeof this.options.bounceEasing == 'string' ? utils.ease[this.options.bounceEasing] || utils.ease.circular : this.options.bounceEasing;

	this.options.resizePolling = this.options.resizePolling === undefined ? 60 : this.options.resizePolling;

	if ( this.options.tap === true ) {
		this.options.tap = 'tap';
	}

	if ( this.options.shrinkScrollbars == 'scale' ) {
		this.options.useTransition = false;
	}

	this.options.invertWheelDirection = this.options.invertWheelDirection ? -1 : 1;

// INSERT POINT: NORMALIZATION

	// Some defaults	
	this.x = 0;
	this.y = 0;
	this.directionX = 0;
	this.directionY = 0;
	this._events = {};

// INSERT POINT: DEFAULTS

	this._init();
	this.refresh();

	this.scrollTo(this.options.startX, this.options.startY);
	this.enable();
	this.tapRequestFlag = 0;
	this.aniTime = null;
}

IScroll.prototype = {
	version: '5.1.3',
	_init: function () {
		this._initEvents();

		if ( this.options.scrollbars || this.options.indicators ) {
			this._initIndicators();
		}

		if ( this.options.mouseWheel ) {
			this._initWheel();
		}

		if ( this.options.snap ) {
			this._initSnap();
		}

		if ( this.options.keyBindings ) {
			this._initKeys();
		}

// INSERT POINT: _init

	},

	destroy: function () {
		this._initEvents(true);

		this._execEvent('destroy');
	},

	_transitionEnd: function (e) {
		if ( e.target != this.scroller || !this.isInTransition ) {
			return;
		}

		this._transitionTime();
		if ( !this.resetPosition(this.options.bounceTime) ) {
			this.isInTransition = false;
			this._execEvent('scrollEnd');
		}
	},

	_start: function (e) {
		// React to left mouse button only
		if ( utils.eventType[e.type] != 1 ) {
			if ( e.button !== 0 ) {
				return;
			}
		}

		if ( !this.enabled || (this.initiated && utils.eventType[e.type] !== this.initiated) ) {
			return;
		}

		if ( this.options.preventDefault && !utils.isBadAndroid && !utils.preventDefaultException(e.target, this.options.preventDefaultException) ) {
			e.preventDefault();
		}

		var point = e.touches ? e.touches[0] : e,
			pos;

		this.initiated	= utils.eventType[e.type];
		this.moved		= false;
		this.distX		= 0;
		this.distY		= 0;
		this.directionX = 0;
		this.directionY = 0;
		this.directionLocked = 0;

		this._transitionTime();

		this.startTime = utils.getTime();

		if ( this.options.useTransition && this.isInTransition ) {
			this.isInTransition = false;
			pos = this.getComputedPosition();
			this._translate(Math.round(pos.x), Math.round(pos.y));
			this._execEvent('scrollEnd');
		} else if ( !this.options.useTransition && this.isAnimating ) {
			this.isAnimating = false;
			this.tapRequestFlag = 2;
			cancelRAF(this.aniTime);
			this._execEvent('scrollEnd');
		}

		this.startX    = this.x;
		this.startY    = this.y;
		this.absStartX = this.x;
		this.absStartY = this.y;
		this.pointX    = point.pageX;
		this.pointY    = point.pageY;

		this._execEvent('beforeScrollStart');
	},

	_move: function (e) {
		if ( !this.enabled || utils.eventType[e.type] !== this.initiated ) {
			return;
		}

		if ( this.options.preventDefault ) {	// increases performance on Android? TODO: check!
			e.preventDefault();
		}

		var point		= e.touches ? e.touches[0] : e,
			deltaX		= point.pageX - this.pointX,
			deltaY		= point.pageY - this.pointY,
			timestamp	= utils.getTime(),
			newX, newY,
			absDistX, absDistY;

		this.pointX		= point.pageX;
		this.pointY		= point.pageY;

		this.distX		+= deltaX;
		this.distY		+= deltaY;
		absDistX		= Math.abs(this.distX);
		absDistY		= Math.abs(this.distY);

		// We need to move at least 10 pixels for the scrolling to initiate
		if ( timestamp - this.endTime > 300 && (absDistX < 10 && absDistY < 10) ) {
			return;
		}

		// If you are scrolling in one direction lock the other
		if ( !this.directionLocked && !this.options.freeScroll ) {
			if ( absDistX > absDistY + this.options.directionLockThreshold ) {
				this.directionLocked = 'h';		// lock horizontally
			} else if ( absDistY >= absDistX + this.options.directionLockThreshold ) {
				this.directionLocked = 'v';		// lock vertically
			} else {
				this.directionLocked = 'n';		// no lock
			}
		}

		if ( this.directionLocked == 'h' ) {
			if ( this.options.eventPassthrough == 'vertical' ) {
				e.preventDefault();
			} else if ( this.options.eventPassthrough == 'horizontal' ) {
				this.initiated = false;
				return;
			}

			deltaY = 0;
		} else if ( this.directionLocked == 'v' ) {
			if ( this.options.eventPassthrough == 'horizontal' ) {
				e.preventDefault();
			} else if ( this.options.eventPassthrough == 'vertical' ) {
				this.initiated = false;
				return;
			}

			deltaX = 0;
		}

		deltaX = this.hasHorizontalScroll ? deltaX : 0;
		deltaY = this.hasVerticalScroll ? deltaY : 0;

		newX = this.x + deltaX;
		newY = this.y + deltaY;

		// Slow down if outside of the boundaries
		if ( newX > 0 || newX < this.maxScrollX ) {
			newX = this.options.bounce ? this.x + deltaX / 3 : newX > 0 ? 0 : this.maxScrollX;
		}
		if ( newY > 0 || newY < this.maxScrollY ) {
			newY = this.options.bounce ? this.y + deltaY / 3 : newY > 0 ? 0 : this.maxScrollY;
		}

		this.directionX = deltaX > 0 ? -1 : deltaX < 0 ? 1 : 0;
		this.directionY = deltaY > 0 ? -1 : deltaY < 0 ? 1 : 0;

		if ( !this.moved ) {
			this._execEvent('scrollStart');
		}

		this.moved = true;

		this._translate(newX, newY);

		/* REPLACE START: _move */

		// if ( timestamp - this.startTime > 300 ) {
		// 	this.startTime = timestamp;
		// 	this.startX = this.x;
		// 	this.startY = this.y;
		// }

		/* REPLACE END: _move */

	},

	_end: function (e) {
		if ( !this.enabled || utils.eventType[e.type] !== this.initiated ) {
			return;
		}

		if ( this.options.preventDefault && !utils.preventDefaultException(e.target, this.options.preventDefaultException) ) {
			e.preventDefault();
		}

		var point = e.changedTouches ? e.changedTouches[0] : e,
			momentumX,
			momentumY,
			duration = utils.getTime() - this.startTime,
			newX = Math.round(this.x),
			newY = Math.round(this.y),
			distanceX = Math.abs(newX - this.startX),
			distanceY = Math.abs(newY - this.startY),
			time = 0,
			easing = '';

		this.isInTransition = 0;
		this.initiated = 0;
		this.endTime = utils.getTime();

		// reset if we are outside of the boundaries
		if ( this.resetPosition(this.options.bounceTime) ) {
			return;
		}

		this.scrollTo(newX, newY);	// ensures that the last position is rounded

		// we scrolled less than 10 pixels
		if ( !this.moved ) {
			if ( this.options.tap ) {
				utils.tap(e, this.options.tap);
			}

			if ( this.options.click ) {
				utils.click(e);
			}

			var that = this;
			if(that.tapRequestFlag === 2){
				that.scrollTo(newX, newY, 300, easing);
				return;
			}
			this._execEvent('scrollCancel',e);
			if(that.tapRequestFlag === 1){
				this._execEvent('scrollEnd',e);
			}
			return;
		}

		if ( this._events.flick && duration < 200 && distanceX < 100 && distanceY < 100 ) {
			this._execEvent('flick');
			return;
		}

		// start momentum animation if needed
		if ( this.options.momentum) {
			//@xiaoyue3 modified 2015-06-04
			//此处时间限制放开，>=300 强制设置300，是希望scrollTo方法执行不涉及时间限制
			var tm;
			if(duration >= 300){
				tm = 300;
			}else{
				tm = duration;
			}
			momentumX = this.hasHorizontalScroll ? utils.momentum(this.x, this.startX, tm, this.maxScrollX, this.options.bounce ? this.wrapperWidth : 0, this.options.deceleration) : { destination: newX, duration: 0 };
			momentumY = this.hasVerticalScroll ? utils.momentum(this.y, this.startY, tm, this.maxScrollY, this.options.bounce ? this.wrapperHeight : 0, this.options.deceleration) : { destination: newY, duration: 0 };
			newX = momentumX.destination;
			newY = momentumY.destination;
			time = Math.max(momentumX.duration, momentumY.duration);
			this.isInTransition = 1;
		}

		if ( this.options.snap ) {
			var snap = this._nearestSnap(newX, newY);
			this.currentPage = snap;
			time = this.options.snapSpeed || Math.max(
					Math.max(
						Math.min(Math.abs(newX - snap.x), 1000),
						Math.min(Math.abs(newY - snap.y), 1000)
					), 300);
			newX = snap.x;
			newY = snap.y;

			this.directionX = 0;
			this.directionY = 0;
			easing = this.options.bounceEasing;
		}

		// INSERT POINT: _end

		if ( newX != this.x || newY != this.y ) {
			// change easing function when scroller goes out of the boundaries
			if ( newX > 0 || newX < this.maxScrollX || newY > 0 || newY < this.maxScrollY ) {
				easing = utils.ease.quadratic;
			}
			// console.log('scroll momentum pos');
			this.scrollTo(newX, newY, time, easing);
			return;
		}

		this._execEvent('scrollEnd');
	},

	_resize: function () {
		var that = this;

		clearTimeout(this.resizeTimeout);

		this.resizeTimeout = setTimeout(function () {
			that.refresh();
		}, this.options.resizePolling);
	},

	resetPosition: function (time) {
		var x = this.x,
			y = this.y;

		time = time || 0;

		if ( !this.hasHorizontalScroll || this.x > 0 ) {
			x = 0;
		} else if ( this.x < this.maxScrollX ) {
			x = this.maxScrollX;
		}

		if ( !this.hasVerticalScroll || this.y > 0 ) {
			y = 0;
		} else if ( this.y < this.maxScrollY ) {
			y = this.maxScrollY;
		}

		if ( x == this.x && y == this.y ) {
			// console.log('resetPosition return');
			return false;
		}
		// console.log('resetPosition');
		this.scrollTo(x, y, time, this.options.bounceEasing);

		return true;
	},

	disable: function () {
		this.enabled = false;
	},

	enable: function () {
		this.enabled = true;
	},

	refresh: function () {
		var rf = this.wrapper.offsetHeight;		// Force reflow

		this.wrapperWidth	= this.wrapper.clientWidth;
		this.wrapperHeight	= this.wrapper.clientHeight;

/* REPLACE START: refresh */

		this.scrollerWidth	= this.scroller.offsetWidth;
		this.scrollerHeight	= this.scroller.offsetHeight;

		this.maxScrollX		= this.wrapperWidth - this.scrollerWidth;
		this.maxScrollY		= this.wrapperHeight - this.scrollerHeight;

/* REPLACE END: refresh */

		this.hasHorizontalScroll	= this.options.scrollX && this.maxScrollX < 0;
		this.hasVerticalScroll		= this.options.scrollY && this.maxScrollY < 0;

		if ( !this.hasHorizontalScroll ) {
			this.maxScrollX = 0;
			this.scrollerWidth = this.wrapperWidth;
		}

		if ( !this.hasVerticalScroll ) {
			this.maxScrollY = 0;
			this.scrollerHeight = this.wrapperHeight;
		}

		this.endTime = 0;
		this.directionX = 0;
		this.directionY = 0;

		this.wrapperOffset = utils.offset(this.wrapper);

		this._execEvent('refresh');

		this.resetPosition();

// INSERT POINT: _refresh

	},

	on: function (type, fn) {
		if ( !this._events[type] ) {
			this._events[type] = [];
		}

		this._events[type].push(fn);
	},

	off: function (type, fn) {
		if ( !this._events[type] ) {
			return;
		}

		var index = this._events[type].indexOf(fn);

		if ( index > -1 ) {
			this._events[type].splice(index, 1);
		}
	},

	_execEvent: function (type) {
		if ( !this._events[type] ) {
			return;
		}

		var i = 0,
			l = this._events[type].length;

		if ( !l ) {
			return;
		}

		for ( ; i < l; i++ ) {
			this._events[type][i].apply(this, [].slice.call(arguments, 1));
		}
	},

	scrollBy: function (x, y, time, easing) {
		x = this.x + x;
		y = this.y + y;
		time = time || 0;

		this.scrollTo(x, y, time, easing);
	},

	scrollTo: function (x, y, time, easing) {
		easing = easing || utils.ease.circular;

		this.isInTransition = this.options.useTransition && time > 0;

		if ( !time || (this.options.useTransition && easing.style) ) {
			this._transitionTimingFunction(easing.style);
			this._transitionTime(time);
			this._translate(x, y);
		} else {
			this._animate(x, y, time, easing.fn);
		}
	},

	scrollToElement: function (el, time, offsetX, offsetY, easing) {
		el = el.nodeType ? el : this.scroller.querySelector(el);

		if ( !el ) {
			return;
		}

		var pos = utils.offset(el);

		pos.left -= this.wrapperOffset.left;
		pos.top  -= this.wrapperOffset.top;

		// if offsetX/Y are true we center the element to the screen
		if ( offsetX === true ) {
			offsetX = Math.round(el.offsetWidth / 2 - this.wrapper.offsetWidth / 2);
		}
		if ( offsetY === true ) {
			offsetY = Math.round(el.offsetHeight / 2 - this.wrapper.offsetHeight / 2);
		}

		pos.left -= offsetX || 0;
		pos.top  -= offsetY || 0;

		pos.left = pos.left > 0 ? 0 : pos.left < this.maxScrollX ? this.maxScrollX : pos.left;
		pos.top  = pos.top  > 0 ? 0 : pos.top  < this.maxScrollY ? this.maxScrollY : pos.top;

		time = time === undefined || time === null || time === 'auto' ? Math.max(Math.abs(this.x-pos.left), Math.abs(this.y-pos.top)) : time;

		this.scrollTo(pos.left, pos.top, time, easing);
	},

	_transitionTime: function (time) {
		time = time || 0;

		this.scrollerStyle[utils.style.transitionDuration] = time + 'ms';

		if ( !time && utils.isBadAndroid ) {
			this.scrollerStyle[utils.style.transitionDuration] = '0.001s';
		}


		if ( this.indicators ) {
			for ( var i = this.indicators.length; i--; ) {
				this.indicators[i].transitionTime(time);
			}
		}


// INSERT POINT: _transitionTime

	},

	_transitionTimingFunction: function (easing) {
		this.scrollerStyle[utils.style.transitionTimingFunction] = easing;


		if ( this.indicators ) {
			for ( var i = this.indicators.length; i--; ) {
				this.indicators[i].transitionTimingFunction(easing);
			}
		}


// INSERT POINT: _transitionTimingFunction

	},

	_translate: function (x, y) {
		if ( this.options.useTransform ) {
/* REPLACE START: _translate */
		//xiaoyue3@modified 此处改用translate3d 是因为在小米2a下动画比较卡顿，改成这种效果比较好，具体什么原因造成的没有详查。
		//此处默认开启3d加速渲染，后期如果有需要判断是否开启3d加速，此处可添加判断。
		this.scrollerStyle[utils.style.transform] = 'translate3d(' + x + 'px,' + y + 'px, 0px)';
		// this.scrollerStyle[utils.style.transform] = 'translate(' + x + 'px,' + y + 'px)' + this.translateZ;
			

/* REPLACE END: _translate */

		} else {
			x = Math.round(x);
			y = Math.round(y);
			this.scrollerStyle.left = x + 'px';
			this.scrollerStyle.top = y + 'px';
		}

		this.x = x;
		this.y = y;


	if ( this.indicators ) {
		for ( var i = this.indicators.length; i--; ) {
			this.indicators[i].updatePosition();
		}
	}


// INSERT POINT: _translate

	},

	_initEvents: function (remove) {
		var eventType = remove ? utils.removeEvent : utils.addEvent,
			target = this.options.bindToWrapper ? this.wrapper : window;

		// eventType(window, 'orientationchange', this);
		// eventType(window, 'resize', this);

		if ( this.options.click ) {
			eventType(this.wrapper, 'click', this, true);
		}

		if ( !this.options.disableMouse ) {
			eventType(this.wrapper, 'mousedown', this);
			eventType(target, 'mousemove', this);
			eventType(target, 'mousecancel', this);
			eventType(target, 'mouseup', this);
		}

		if ( utils.hasPointer && !this.options.disablePointer ) {
			eventType(this.wrapper, utils.prefixPointerEvent('pointerdown'), this);
			eventType(target, utils.prefixPointerEvent('pointermove'), this);
			eventType(target, utils.prefixPointerEvent('pointercancel'), this);
			eventType(target, utils.prefixPointerEvent('pointerup'), this);
		}

		if ( utils.hasTouch && !this.options.disableTouch ) {
			eventType(this.wrapper, 'touchstart', this);
			eventType(target, 'touchmove', this);
			eventType(target, 'touchcancel', this);
			eventType(target, 'touchend', this);
		}

		eventType(this.scroller, 'transitionend', this);
		eventType(this.scroller, 'webkitTransitionEnd', this);
		eventType(this.scroller, 'oTransitionEnd', this);
		eventType(this.scroller, 'MSTransitionEnd', this);
	},

	getComputedPosition: function () {
		var matrix = window.getComputedStyle(this.scroller, null),
			x, y;

		if ( this.options.useTransform ) {
			matrix = matrix[utils.style.transform].split(')')[0].split(', ');
			x = +(matrix[12] || matrix[4]);
			y = +(matrix[13] || matrix[5]);
		} else {
			x = +matrix.left.replace(/[^-\d.]/g, '');
			y = +matrix.top.replace(/[^-\d.]/g, '');
		}

		return { x: x, y: y };
	},

	_initIndicators: function () {
		var interactive = this.options.interactiveScrollbars,
			customStyle = typeof this.options.scrollbars != 'string',
			indicators = [],
			indicator;

		var that = this;

		this.indicators = [];

		if ( this.options.scrollbars ) {
			// Vertical scrollbar
			if ( this.options.scrollY ) {
				indicator = {
					el: createDefaultScrollbar('v', interactive, this.options.scrollbars),
					interactive: interactive,
					defaultScrollbars: true,
					customStyle: customStyle,
					resize: this.options.resizeScrollbars,
					shrink: this.options.shrinkScrollbars,
					fade: this.options.fadeScrollbars,
					listenX: false
				};

				this.wrapper.appendChild(indicator.el);
				indicators.push(indicator);
			}

			// Horizontal scrollbar
			if ( this.options.scrollX ) {
				indicator = {
					el: createDefaultScrollbar('h', interactive, this.options.scrollbars, this.options.scrollBarOpacity),
					interactive: interactive,
					defaultScrollbars: true,
					customStyle: customStyle,
					resize: this.options.resizeScrollbars,
					shrink: this.options.shrinkScrollbars,
					fade: this.options.fadeScrollbars,
					listenY: false
				};

				this.wrapper.appendChild(indicator.el);
				indicators.push(indicator);
			}
		}

		if ( this.options.indicators ) {
			// TODO: check concat compatibility
			indicators = indicators.concat(this.options.indicators);
		}

		for ( var i = indicators.length; i--; ) {
			this.indicators.push( new Indicator(this, indicators[i]) );
		}

		// TODO: check if we can use array.map (wide compatibility and performance issues)
		function _indicatorsMap (fn) {
			for ( var i = that.indicators.length; i--; ) {
				fn.call(that.indicators[i]);
			}
		}

		if ( this.options.fadeScrollbars ) {
			this.on('scrollEnd', function () {
				_indicatorsMap(function () {
					this.fade();
				});
			});

			this.on('scrollCancel', function () {
				_indicatorsMap(function () {
					this.fade();
				});
			});

			this.on('scrollStart', function () {
				_indicatorsMap(function () {
					this.fade(1);
				});
			});

			this.on('beforeScrollStart', function () {
				_indicatorsMap(function () {
					this.fade(1, true);
				});
			});
		}


		this.on('refresh', function () {
			_indicatorsMap(function () {
				this.refresh();
			});
		});

		this.on('destroy', function () {
			_indicatorsMap(function () {
				this.destroy();
			});

			delete this.indicators;
		});
	},

	_initWheel: function () {
		utils.addEvent(this.wrapper, 'wheel', this);
		utils.addEvent(this.wrapper, 'mousewheel', this);
		utils.addEvent(this.wrapper, 'DOMMouseScroll', this);

		this.on('destroy', function () {
			utils.removeEvent(this.wrapper, 'wheel', this);
			utils.removeEvent(this.wrapper, 'mousewheel', this);
			utils.removeEvent(this.wrapper, 'DOMMouseScroll', this);
		});
	},

	_wheel: function (e) {
		if ( !this.enabled ) {
			return;
		}

		e.preventDefault();
		e.stopPropagation();

		var wheelDeltaX, wheelDeltaY,
			newX, newY,
			that = this;

		if ( this.wheelTimeout === undefined ) {
			that._execEvent('scrollStart');
		}

		// Execute the scrollEnd event after 400ms the wheel stopped scrolling
		clearTimeout(this.wheelTimeout);
		this.wheelTimeout = setTimeout(function () {
			that._execEvent('scrollEnd');
			that.wheelTimeout = undefined;
		}, 400);

		if ( 'deltaX' in e ) {
			if (e.deltaMode === 1) {
				wheelDeltaX = -e.deltaX * this.options.mouseWheelSpeed;
				wheelDeltaY = -e.deltaY * this.options.mouseWheelSpeed;
			} else {
				wheelDeltaX = -e.deltaX;
				wheelDeltaY = -e.deltaY;
			}
		} else if ( 'wheelDeltaX' in e ) {
			wheelDeltaX = e.wheelDeltaX / 120 * this.options.mouseWheelSpeed;
			wheelDeltaY = e.wheelDeltaY / 120 * this.options.mouseWheelSpeed;
		} else if ( 'wheelDelta' in e ) {
			wheelDeltaX = wheelDeltaY = e.wheelDelta / 120 * this.options.mouseWheelSpeed;
		} else if ( 'detail' in e ) {
			wheelDeltaX = wheelDeltaY = -e.detail / 3 * this.options.mouseWheelSpeed;
		} else {
			return;
		}

		wheelDeltaX *= this.options.invertWheelDirection;
		wheelDeltaY *= this.options.invertWheelDirection;

		if ( !this.hasVerticalScroll ) {
			wheelDeltaX = wheelDeltaY;
			wheelDeltaY = 0;
		}

		if ( this.options.snap ) {
			newX = this.currentPage.pageX;
			newY = this.currentPage.pageY;

			if ( wheelDeltaX > 0 ) {
				newX--;
			} else if ( wheelDeltaX < 0 ) {
				newX++;
			}

			if ( wheelDeltaY > 0 ) {
				newY--;
			} else if ( wheelDeltaY < 0 ) {
				newY++;
			}

			this.goToPage(newX, newY);

			return;
		}

		newX = this.x + Math.round(this.hasHorizontalScroll ? wheelDeltaX : 0);
		newY = this.y + Math.round(this.hasVerticalScroll ? wheelDeltaY : 0);

		if ( newX > 0 ) {
			newX = 0;
		} else if ( newX < this.maxScrollX ) {
			newX = this.maxScrollX;
		}

		if ( newY > 0 ) {
			newY = 0;
		} else if ( newY < this.maxScrollY ) {
			newY = this.maxScrollY;
		}

		this.scrollTo(newX, newY, 0);

// INSERT POINT: _wheel
	},

	_initSnap: function () {
		this.currentPage = {};

		if ( typeof this.options.snap == 'string' ) {
			this.options.snap = this.scroller.querySelectorAll(this.options.snap);
		}

		//@xiaoyue3 modified 2015-06-04 
		//获取外层wapper元素的offsetleft值
		var wrapperOffsetLeft = this.wrapper.offsetLeft; 

		this.on('refresh', function () {
			var i = 0, l,
				m = 0, n,
				cx, cy,
				x = 0, y,
				stepX = this.options.snapStepX || this.wrapperWidth,
				stepY = this.options.snapStepY || this.wrapperHeight,
				el;

			this.pages = [];

			if ( !this.wrapperWidth || !this.wrapperHeight || !this.scrollerWidth || !this.scrollerHeight ) {
				return;
			}

			if ( this.options.snap === true ) {
				cx = Math.round( stepX / 2 );
				cy = Math.round( stepY / 2 );

				while ( x > -this.scrollerWidth ) {
					this.pages[i] = [];
					l = 0;
					y = 0;

					while ( y > -this.scrollerHeight ) {
						this.pages[i][l] = {
							x: Math.max(x, this.maxScrollX),
							y: Math.max(y, this.maxScrollY),
							width: stepX,
							height: stepY,
							cx: x - cx,
							cy: y - cy
						};

						y -= stepY;
						l++;
					}

					x -= stepX;
					i++;
				}
			} else {
				el = this.options.snap;
				l = el.length;
				n = -1;

				for ( ; i < l; i++ ) {
					if ( i === 0 || el[i].offsetLeft <= el[i-1].offsetLeft ) {
						m = 0;
						n++;
					}

					if ( !this.pages[m] ) {
						this.pages[m] = [];
					}
					//@xiaoyue3 modified 2015-06-04 
					//此处x加上wrapperOffsetLeft是希望snap的时候，获取正确的元素初始滚动距离
					x = Math.max(-el[i].offsetLeft+wrapperOffsetLeft, this.maxScrollX);
					
					y = Math.max(-el[i].offsetTop, this.maxScrollY);
					cx = x - Math.round(el[i].offsetWidth / 2);
					cy = y - Math.round(el[i].offsetHeight / 2);

					this.pages[m][n] = {
						x: x,
						y: y,
						width: el[i].offsetWidth,
						height: el[i].offsetHeight,
						cx: cx,
						cy: cy
					};

					if ( x > this.maxScrollX ) {
						m++;
					}
				}
			}

			this.goToPage(this.currentPage.pageX || 0, this.currentPage.pageY || 0, 0);

			// Update snap threshold if needed
			if ( this.options.snapThreshold % 1 === 0 ) {
				this.snapThresholdX = this.options.snapThreshold;
				this.snapThresholdY = this.options.snapThreshold;
			} else {
				this.snapThresholdX = Math.round(this.pages[this.currentPage.pageX][this.currentPage.pageY].width * this.options.snapThreshold);
				this.snapThresholdY = Math.round(this.pages[this.currentPage.pageX][this.currentPage.pageY].height * this.options.snapThreshold);
			}
		});

		this.on('flick', function () {
			var time = this.options.snapSpeed || Math.max(
					Math.max(
						Math.min(Math.abs(this.x - this.startX), 1000),
						Math.min(Math.abs(this.y - this.startY), 1000)
					), 300);

			this.goToPage(
				this.currentPage.pageX + this.directionX,
				this.currentPage.pageY + this.directionY,
				time
			);
		});
	},

	_nearestSnap: function (x, y) {
		if ( !this.pages.length ) {
			return { x: 0, y: 0, pageX: 0, pageY: 0 };
		}

		var i = 0,
			l = this.pages.length,
			m = 0;

		// Check if we exceeded the snap threshold
		if ( Math.abs(x - this.absStartX) < this.snapThresholdX &&
			Math.abs(y - this.absStartY) < this.snapThresholdY ) {
			return this.currentPage;
		}

		if ( x > 0 ) {
			x = 0;
		} else if ( x < this.maxScrollX ) {
			x = this.maxScrollX;
		}

		if ( y > 0 ) {
			y = 0;
		} else if ( y < this.maxScrollY ) {
			y = this.maxScrollY;
		}

		for ( ; i < l; i++ ) {
			if ( x >= this.pages[i][0].cx ) {
				x = this.pages[i][0].x;
				break;
			}
		}

		l = this.pages[i].length;

		for ( ; m < l; m++ ) {
			if ( y >= this.pages[0][m].cy ) {
				y = this.pages[0][m].y;
				break;
			}
		}

		if ( i == this.currentPage.pageX ) {
			i += this.directionX;

			if ( i < 0 ) {
				i = 0;
			} else if ( i >= this.pages.length ) {
				i = this.pages.length - 1;
			}

			x = this.pages[i][0].x;
		}

		if ( m == this.currentPage.pageY ) {
			m += this.directionY;

			if ( m < 0 ) {
				m = 0;
			} else if ( m >= this.pages[0].length ) {
				m = this.pages[0].length - 1;
			}

			y = this.pages[0][m].y;
		}

		return {
			x: x,
			y: y,
			pageX: i,
			pageY: m
		};
	},

	goToPage: function (x, y, time, easing) {
		easing = easing || this.options.bounceEasing;

		if ( x >= this.pages.length ) {
			x = this.pages.length - 1;
		} else if ( x < 0 ) {
			x = 0;
		}

		if ( y >= this.pages[x].length ) {
			y = this.pages[x].length - 1;
		} else if ( y < 0 ) {
			y = 0;
		}

		var posX = this.pages[x][y].x,
			posY = this.pages[x][y].y;

		time = time === undefined ? this.options.snapSpeed || Math.max(
			Math.max(
				Math.min(Math.abs(posX - this.x), 1000),
				Math.min(Math.abs(posY - this.y), 1000)
			), 300) : time;

		this.currentPage = {
			x: posX,
			y: posY,
			pageX: x,
			pageY: y
		};

		this.scrollTo(posX, posY, time, easing);
	},

	next: function (time, easing) {
		var x = this.currentPage.pageX,
			y = this.currentPage.pageY;

		x++;

		if ( x >= this.pages.length && this.hasVerticalScroll ) {
			x = 0;
			y++;
		}

		this.goToPage(x, y, time, easing);
	},

	prev: function (time, easing) {
		var x = this.currentPage.pageX,
			y = this.currentPage.pageY;

		x--;

		if ( x < 0 && this.hasVerticalScroll ) {
			x = 0;
			y--;
		}

		this.goToPage(x, y, time, easing);
	},

	_initKeys: function (e) {
		// default key bindings
		var keys = {
			pageUp: 33,
			pageDown: 34,
			end: 35,
			home: 36,
			left: 37,
			up: 38,
			right: 39,
			down: 40
		};
		var i;

		// if you give me characters I give you keycode
		if ( typeof this.options.keyBindings == 'object' ) {
			for ( i in this.options.keyBindings ) {
				if ( typeof this.options.keyBindings[i] == 'string' ) {
					this.options.keyBindings[i] = this.options.keyBindings[i].toUpperCase().charCodeAt(0);
				}
			}
		} else {
			this.options.keyBindings = {};
		}

		for ( i in keys ) {
			this.options.keyBindings[i] = this.options.keyBindings[i] || keys[i];
		}

		utils.addEvent(window, 'keydown', this);

		this.on('destroy', function () {
			utils.removeEvent(window, 'keydown', this);
		});
	},

	_key: function (e) {
		if ( !this.enabled ) {
			return;
		}

		var snap = this.options.snap,	// we are using this alot, better to cache it
			newX = snap ? this.currentPage.pageX : this.x,
			newY = snap ? this.currentPage.pageY : this.y,
			now = utils.getTime(),
			prevTime = this.keyTime || 0,
			acceleration = 0.250,
			pos;

		if ( this.options.useTransition && this.isInTransition ) {
			pos = this.getComputedPosition();

			this._translate(Math.round(pos.x), Math.round(pos.y));
			this.isInTransition = false;
		}

		this.keyAcceleration = now - prevTime < 200 ? Math.min(this.keyAcceleration + acceleration, 50) : 0;

		switch ( e.keyCode ) {
			case this.options.keyBindings.pageUp:
				if ( this.hasHorizontalScroll && !this.hasVerticalScroll ) {
					newX += snap ? 1 : this.wrapperWidth;
				} else {
					newY += snap ? 1 : this.wrapperHeight;
				}
				break;
			case this.options.keyBindings.pageDown:
				if ( this.hasHorizontalScroll && !this.hasVerticalScroll ) {
					newX -= snap ? 1 : this.wrapperWidth;
				} else {
					newY -= snap ? 1 : this.wrapperHeight;
				}
				break;
			case this.options.keyBindings.end:
				newX = snap ? this.pages.length-1 : this.maxScrollX;
				newY = snap ? this.pages[0].length-1 : this.maxScrollY;
				break;
			case this.options.keyBindings.home:
				newX = 0;
				newY = 0;
				break;
			case this.options.keyBindings.left:
				newX += snap ? -1 : 5 + this.keyAcceleration>>0;
				break;
			case this.options.keyBindings.up:
				newY += snap ? 1 : 5 + this.keyAcceleration>>0;
				break;
			case this.options.keyBindings.right:
				newX -= snap ? -1 : 5 + this.keyAcceleration>>0;
				break;
			case this.options.keyBindings.down:
				newY -= snap ? 1 : 5 + this.keyAcceleration>>0;
				break;
			default:
				return;
		}

		if ( snap ) {
			this.goToPage(newX, newY);
			return;
		}

		if ( newX > 0 ) {
			newX = 0;
			this.keyAcceleration = 0;
		} else if ( newX < this.maxScrollX ) {
			newX = this.maxScrollX;
			this.keyAcceleration = 0;
		}

		if ( newY > 0 ) {
			newY = 0;
			this.keyAcceleration = 0;
		} else if ( newY < this.maxScrollY ) {
			newY = this.maxScrollY;
			this.keyAcceleration = 0;
		}

		this.scrollTo(newX, newY, 0);

		this.keyTime = now;
	},

	_animate: function (destX, destY, duration, easingFn) {
		var that = this,
			startX = this.x,
			startY = this.y,
			startTime = utils.getTime(),
			destTime = startTime + duration;

		function step () {
			var now = utils.getTime(),
				newX, newY,
				easing;

			if ( now >= destTime ) {
				that.isAnimating = false;
				// console.log('destX4444444s',destX);
				that._translate(destX, destY);
				if ( !that.resetPosition(that.options.bounceTime) ) {
					that._execEvent('scrollEnd');
					that.tapRequestFlag = 0;
				}
				return;
			}

			now = ( now - startTime ) / duration;
			easing = easingFn(now);
			newX = ( destX - startX ) * easing + startX;
			newY = ( destY - startY ) * easing + startY;
			that._translate(newX, newY);
			if ( that.isAnimating ) {
				that.aniTime = rAF(step);
			}
		}
		this.isAnimating = true;
		step();
	},
	handleEvent: function (e) {
		switch ( e.type ) {
			case 'touchstart':
			case 'pointerdown':
			case 'MSPointerDown':
			case 'mousedown':
				this._start(e);
				break;
			case 'touchmove':
			case 'pointermove':
			case 'MSPointerMove':
			case 'mousemove':
				this._move(e);
				break;
			case 'touchend':
			case 'pointerup':
			case 'MSPointerUp':
			case 'mouseup':
			case 'touchcancel':
			case 'pointercancel':
			case 'MSPointerCancel':
			case 'mousecancel':
				this._end(e);
				break;
			case 'orientationchange':
			case 'resize':
				this._resize();
				break;
			case 'transitionend':
			case 'webkitTransitionEnd':
			case 'oTransitionEnd':
			case 'MSTransitionEnd':
				this._transitionEnd(e);
				break;
			case 'wheel':
			case 'DOMMouseScroll':
			case 'mousewheel':
				this._wheel(e);
				break;
			case 'keydown':
				this._key(e);
				break;
			case 'click':
				if ( !e._constructed ) {
					e.preventDefault();
					e.stopPropagation();
				}
				break;
		}
	}
};
function createDefaultScrollbar (direction, interactive, type, opacity) {
	var scrollbar = document.createElement('div'),
		indicator = document.createElement('div');

	if ( type === true ) {
		scrollbar.style.cssText = 'position:absolute;z-index:9999';
		indicator.style.cssText = '-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;position:absolute;background:rgba(0,0,0,0.5);border:1px solid rgba(255,255,255,'+ opacity +');border-radius:3px';
	}

	indicator.className = 'iScrollIndicator';

	if ( direction == 'h' ) {
		if ( type === true ) {
			scrollbar.style.cssText += ';height:7px;left:2px;right:2px;bottom:0';
			indicator.style.height = '100%';
		}
		scrollbar.className = 'iScrollHorizontalScrollbar';
	} else {
		if ( type === true ) {
			scrollbar.style.cssText += ';width:7px;bottom:2px;top:2px;right:1px';
			indicator.style.width = '100%';
		}
		scrollbar.className = 'iScrollVerticalScrollbar';
	}

	scrollbar.style.cssText += ';overflow:hidden';

	if ( !interactive ) {
		scrollbar.style.pointerEvents = 'none';
	}

	scrollbar.appendChild(indicator);

	return scrollbar;
}

function Indicator (scroller, options) {
	this.wrapper = typeof options.el == 'string' ? document.querySelector(options.el) : options.el;
	this.wrapperStyle = this.wrapper.style;
	this.indicator = this.wrapper.children[0];
	this.indicatorStyle = this.indicator.style;
	this.scroller = scroller;

	this.options = {
		listenX: true,
		listenY: true,
		interactive: false,
		resize: true,
		defaultScrollbars: false,
		shrink: false,
		fade: false,
		speedRatioX: 0,
		speedRatioY: 0
	};

	for ( var i in options ) {
		this.options[i] = options[i];
	}

	this.sizeRatioX = 1;
	this.sizeRatioY = 1;
	this.maxPosX = 0;
	this.maxPosY = 0;

	if ( this.options.interactive ) {
		if ( !this.options.disableTouch ) {
			utils.addEvent(this.indicator, 'touchstart', this);
			utils.addEvent(window, 'touchend', this);
		}
		if ( !this.options.disablePointer ) {
			utils.addEvent(this.indicator, utils.prefixPointerEvent('pointerdown'), this);
			utils.addEvent(window, utils.prefixPointerEvent('pointerup'), this);
		}
		if ( !this.options.disableMouse ) {
			utils.addEvent(this.indicator, 'mousedown', this);
			utils.addEvent(window, 'mouseup', this);
		}
	}

	if ( this.options.fade ) {
		this.wrapperStyle[utils.style.transform] = this.scroller.translateZ;
		this.wrapperStyle[utils.style.transitionDuration] = utils.isBadAndroid ? '0.001s' : '0ms';
		this.wrapperStyle.opacity = '0';
	}
}

Indicator.prototype = {
	handleEvent: function (e) {
		switch ( e.type ) {
			case 'touchstart':
			case 'pointerdown':
			case 'MSPointerDown':
			case 'mousedown':
				this._start(e);
				break;
			case 'touchmove':
			case 'pointermove':
			case 'MSPointerMove':
			case 'mousemove':
				this._move(e);
				break;
			case 'touchend':
			case 'pointerup':
			case 'MSPointerUp':
			case 'mouseup':
			case 'touchcancel':
			case 'pointercancel':
			case 'MSPointerCancel':
			case 'mousecancel':
				this._end(e);
				break;
		}
	},

	destroy: function () {
		if ( this.options.interactive ) {
			utils.removeEvent(this.indicator, 'touchstart', this);
			utils.removeEvent(this.indicator, utils.prefixPointerEvent('pointerdown'), this);
			utils.removeEvent(this.indicator, 'mousedown', this);

			utils.removeEvent(window, 'touchmove', this);
			utils.removeEvent(window, utils.prefixPointerEvent('pointermove'), this);
			utils.removeEvent(window, 'mousemove', this);

			utils.removeEvent(window, 'touchend', this);
			utils.removeEvent(window, utils.prefixPointerEvent('pointerup'), this);
			utils.removeEvent(window, 'mouseup', this);
		}

		if ( this.options.defaultScrollbars ) {
			this.wrapper.parentNode.removeChild(this.wrapper);
		}
	},

	_start: function (e) {
		var point = e.touches ? e.touches[0] : e;

		e.preventDefault();
		e.stopPropagation();

		this.transitionTime();

		this.initiated = true;
		this.moved = false;
		this.lastPointX	= point.pageX;
		this.lastPointY	= point.pageY;

		this.startTime	= utils.getTime();

		if ( !this.options.disableTouch ) {
			utils.addEvent(window, 'touchmove', this);
		}
		if ( !this.options.disablePointer ) {
			utils.addEvent(window, utils.prefixPointerEvent('pointermove'), this);
		}
		if ( !this.options.disableMouse ) {
			utils.addEvent(window, 'mousemove', this);
		}

		this.scroller._execEvent('beforeScrollStart');
	},

	_move: function (e) {
		var point = e.touches ? e.touches[0] : e,
			deltaX, deltaY,
			newX, newY,
			timestamp = utils.getTime();

		if ( !this.moved ) {
			this.scroller._execEvent('scrollStart');
		}

		this.moved = true;

		deltaX = point.pageX - this.lastPointX;
		this.lastPointX = point.pageX;

		deltaY = point.pageY - this.lastPointY;
		this.lastPointY = point.pageY;

		newX = this.x + deltaX;
		newY = this.y + deltaY;

		this._pos(newX, newY);

// INSERT POINT: indicator._move

		e.preventDefault();
		e.stopPropagation();
	},

	_end: function (e) {
		if ( !this.initiated ) {
			return;
		}

		this.initiated = false;

		e.preventDefault();
		e.stopPropagation();

		utils.removeEvent(window, 'touchmove', this);
		utils.removeEvent(window, utils.prefixPointerEvent('pointermove'), this);
		utils.removeEvent(window, 'mousemove', this);

		if ( this.scroller.options.snap ) {
			var snap = this.scroller._nearestSnap(this.scroller.x, this.scroller.y);

			var time = this.options.snapSpeed || Math.max(
					Math.max(
						Math.min(Math.abs(this.scroller.x - snap.x), 1000),
						Math.min(Math.abs(this.scroller.y - snap.y), 1000)
					), 300);

			if ( this.scroller.x != snap.x || this.scroller.y != snap.y ) {
				this.scroller.directionX = 0;
				this.scroller.directionY = 0;
				this.scroller.currentPage = snap;
				this.scroller.scrollTo(snap.x, snap.y, time, this.scroller.options.bounceEasing);
			}
		}

		if ( this.moved ) {
			this.scroller._execEvent('scrollEnd');
		}
	},

	transitionTime: function (time) {
		time = time || 0;
		this.indicatorStyle[utils.style.transitionDuration] = time + 'ms';

		if ( !time && utils.isBadAndroid ) {
			this.indicatorStyle[utils.style.transitionDuration] = '0.001s';
		}
	},

	transitionTimingFunction: function (easing) {
		this.indicatorStyle[utils.style.transitionTimingFunction] = easing;
	},

	refresh: function () {
		this.transitionTime();

		if ( this.options.listenX && !this.options.listenY ) {
			this.indicatorStyle.display = this.scroller.hasHorizontalScroll ? 'block' : 'none';
		} else if ( this.options.listenY && !this.options.listenX ) {
			this.indicatorStyle.display = this.scroller.hasVerticalScroll ? 'block' : 'none';
		} else {
			this.indicatorStyle.display = this.scroller.hasHorizontalScroll || this.scroller.hasVerticalScroll ? 'block' : 'none';
		}

		if ( this.scroller.hasHorizontalScroll && this.scroller.hasVerticalScroll ) {
			utils.addClass(this.wrapper, 'iScrollBothScrollbars');
			utils.removeClass(this.wrapper, 'iScrollLoneScrollbar');

			if ( this.options.defaultScrollbars && this.options.customStyle ) {
				if ( this.options.listenX ) {
					this.wrapper.style.right = '8px';
				} else {
					this.wrapper.style.bottom = '8px';
				}
			}
		} else {
			utils.removeClass(this.wrapper, 'iScrollBothScrollbars');
			utils.addClass(this.wrapper, 'iScrollLoneScrollbar');

			if ( this.options.defaultScrollbars && this.options.customStyle ) {
				if ( this.options.listenX ) {
					this.wrapper.style.right = '2px';
				} else {
					this.wrapper.style.bottom = '2px';
				}
			}
		}

		var r = this.wrapper.offsetHeight;	// force refresh

		if ( this.options.listenX ) {
			this.wrapperWidth = this.wrapper.clientWidth;
			if ( this.options.resize ) {
				this.indicatorWidth = Math.max(Math.round(this.wrapperWidth * this.wrapperWidth / (this.scroller.scrollerWidth || this.wrapperWidth || 1)), 8);
				this.indicatorStyle.width = this.indicatorWidth + 'px';
			} else {
				this.indicatorWidth = this.indicator.clientWidth;
			}

			this.maxPosX = this.wrapperWidth - this.indicatorWidth;

			if ( this.options.shrink == 'clip' ) {
				this.minBoundaryX = -this.indicatorWidth + 8;
				this.maxBoundaryX = this.wrapperWidth - 8;
			} else {
				this.minBoundaryX = 0;
				this.maxBoundaryX = this.maxPosX;
			}

			this.sizeRatioX = this.options.speedRatioX || (this.scroller.maxScrollX && (this.maxPosX / this.scroller.maxScrollX));	
		}

		if ( this.options.listenY ) {
			this.wrapperHeight = this.wrapper.clientHeight;
			if ( this.options.resize ) {
				this.indicatorHeight = Math.max(Math.round(this.wrapperHeight * this.wrapperHeight / (this.scroller.scrollerHeight || this.wrapperHeight || 1)), 8);
				this.indicatorStyle.height = this.indicatorHeight + 'px';
			} else {
				this.indicatorHeight = this.indicator.clientHeight;
			}

			this.maxPosY = this.wrapperHeight - this.indicatorHeight;

			if ( this.options.shrink == 'clip' ) {
				this.minBoundaryY = -this.indicatorHeight + 8;
				this.maxBoundaryY = this.wrapperHeight - 8;
			} else {
				this.minBoundaryY = 0;
				this.maxBoundaryY = this.maxPosY;
			}

			this.maxPosY = this.wrapperHeight - this.indicatorHeight;
			this.sizeRatioY = this.options.speedRatioY || (this.scroller.maxScrollY && (this.maxPosY / this.scroller.maxScrollY));
		}

		this.updatePosition();
	},

	updatePosition: function () {
		var x = this.options.listenX && Math.round(this.sizeRatioX * this.scroller.x) || 0,
			y = this.options.listenY && Math.round(this.sizeRatioY * this.scroller.y) || 0;

		if ( !this.options.ignoreBoundaries ) {
			if ( x < this.minBoundaryX ) {
				if ( this.options.shrink == 'scale' ) {
					this.width = Math.max(this.indicatorWidth + x, 8);
					this.indicatorStyle.width = this.width + 'px';
				}
				x = this.minBoundaryX;
			} else if ( x > this.maxBoundaryX ) {
				if ( this.options.shrink == 'scale' ) {
					this.width = Math.max(this.indicatorWidth - (x - this.maxPosX), 8);
					this.indicatorStyle.width = this.width + 'px';
					x = this.maxPosX + this.indicatorWidth - this.width;
				} else {
					x = this.maxBoundaryX;
				}
			} else if ( this.options.shrink == 'scale' && this.width != this.indicatorWidth ) {
				this.width = this.indicatorWidth;
				this.indicatorStyle.width = this.width + 'px';
			}

			if ( y < this.minBoundaryY ) {
				if ( this.options.shrink == 'scale' ) {
					this.height = Math.max(this.indicatorHeight + y * 3, 8);
					this.indicatorStyle.height = this.height + 'px';
				}
				y = this.minBoundaryY;
			} else if ( y > this.maxBoundaryY ) {
				if ( this.options.shrink == 'scale' ) {
					this.height = Math.max(this.indicatorHeight - (y - this.maxPosY) * 3, 8);
					this.indicatorStyle.height = this.height + 'px';
					y = this.maxPosY + this.indicatorHeight - this.height;
				} else {
					y = this.maxBoundaryY;
				}
			} else if ( this.options.shrink == 'scale' && this.height != this.indicatorHeight ) {
				this.height = this.indicatorHeight;
				this.indicatorStyle.height = this.height + 'px';
			}
		}

		this.x = x;
		this.y = y;

		if ( this.scroller.options.useTransform ) {
			this.indicatorStyle[utils.style.transform] = 'translate(' + x + 'px,' + y + 'px)' + this.scroller.translateZ;
		} else {
			this.indicatorStyle.left = x + 'px';
			this.indicatorStyle.top = y + 'px';
		}
	},

	_pos: function (x, y) {
		if ( x < 0 ) {
			x = 0;
		} else if ( x > this.maxPosX ) {
			x = this.maxPosX;
		}

		if ( y < 0 ) {
			y = 0;
		} else if ( y > this.maxPosY ) {
			y = this.maxPosY;
		}

		x = this.options.listenX ? Math.round(x / this.sizeRatioX) : this.scroller.x;
		y = this.options.listenY ? Math.round(y / this.sizeRatioY) : this.scroller.y;

		this.scroller.scrollTo(x, y);
	},

	fade: function (val, hold) {
		if ( hold && !this.visible ) {
			return;
		}

		clearTimeout(this.fadeTimeout);
		this.fadeTimeout = null;

		var time = val ? 250 : 500,
			delay = val ? 0 : 300;

		val = val ? '1' : '0';

		this.wrapperStyle[utils.style.transitionDuration] = time + 'ms';

		this.fadeTimeout = setTimeout((function (val) {
			this.wrapperStyle.opacity = val;
			this.visible = +val;
            var _this = this;
            setTimeout(function(){
                _this.wrapperStyle.display = 'none';
                _this.wrapperStyle.display = 'block';
            },time)
		}).bind(this, val), delay);
	}
};

IScroll.utils = utils;

if ( typeof module != 'undefined' && module.exports ) {
	module.exports = IScroll;
} else {
	window.IScroll = IScroll;
}

})(window, document, Math);

});

/**
 * @fileoverview 业务内全局广播
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('mods/channel/global',function(require,exports,module){

	var $listener = require('lib/common/listener');
	module.exports = new $listener([
		'notice-audio-pause',
		'share-to',
	]);
});

/**
 * @fileoverview 修正补位
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 * @param {String} str 字符串
 * @param {Number} w 补位数量
 * @returns {String} 经过补位的字符串
 * @example
	var $fixTo = require('lib/kit/num/fixTo');
	$fixTo('0',2);	//return '00'
 */
define('lib/kit/num/fixTo', function(require,exports,module) {

	module.exports = function(str, w){
		str = str.toString();
		w = Math.max((w || 2) - str.length + 1, 0);
		return	new Array(w).join('0') + str;
	};

});



/**
 * @fileoverview 模板管理器
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 * @example
	var $tpl = require('lib/kit/util/template');
	var TPL = $tpl({
		item : [
			'<div>',
				'<a href="#">test</a>',
			'</div>'
		]
	});
	TPL.get('item');	//'<div><a href="#">test</a></div>'
 */
define('lib/kit/util/template',function(require,exports,module){

	var $ = require('lib');

	module.exports = function(obj){
		var tpl = {};
		var that = {};
		
		that.set = function(object){
			$.extend(that, object);
			$.extend(tpl, object);
		};

		that.get = function(name){
			var str = '';
			var part = tpl[name];
			if(part){
				if(typeof part === 'string'){
					str = part;
				}else if(Array.isArray(part)){
					tpl[name] = str = part.join('');
				}
			}
			return str;
		};

		that.set(obj);

		return that;
	};

});


/**
 * @fileoverview 模板渲染
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 */

define('vendor/mustache',function(require,exports,module){

/*!
 * mustache.js - Logic-less {{mustache}} templates with JavaScript
 * http://github.com/janl/mustache.js
 */

/*global define: false*/

  exports.name = "mustache.js";
  exports.version = "0.7.2";
  exports.tags = ["{{", "}}"];

  exports.Scanner = Scanner;
  exports.Context = Context;
  exports.Writer = Writer;

  var whiteRe = /\s*/;
  var spaceRe = /\s+/;
  var nonSpaceRe = /\S/;
  var eqRe = /\s*=/;
  var curlyRe = /\s*\}/;
  var tagRe = /#|\^|\/|>|\{|&|=|!/;

  // Workaround for https://issues.apache.org/jira/browse/COUCHDB-577
  // See https://github.com/janl/mustache.js/issues/189
  function testRe(re, string) {
    return RegExp.prototype.test.call(re, string);
  }

  function isWhitespace(string) {
    return !testRe(nonSpaceRe, string);
  }

  var isArray = Array.isArray || function (obj) {
    return Object.prototype.toString.call(obj) === "[object Array]";
  };

  function escapeRe(string) {
    return string.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&");
  }

  var entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
  };

  function escapeHtml(string) {
    return String(string).replace(/[&<>"'\/]/g, function (s) {
      return entityMap[s];
    });
  }

  // Export the escaping function so that the user may override it.
  // See https://github.com/janl/mustache.js/issues/244
  exports.escape = escapeHtml;

  function Scanner(string) {
    this.string = string;
    this.tail = string;
    this.pos = 0;
  }

  /**
   * Returns `true` if the tail is empty (end of string).
   */
  Scanner.prototype.eos = function () {
    return this.tail === "";
  };

  /**
   * Tries to match the given regular expression at the current position.
   * Returns the matched text if it can match, the empty string otherwise.
   */
  Scanner.prototype.scan = function (re) {
    var match = this.tail.match(re);

    if (match && match.index === 0) {
      this.tail = this.tail.substring(match[0].length);
      this.pos += match[0].length;
      return match[0];
    }

    return "";
  };

  /**
   * Skips all text until the given regular expression can be matched. Returns
   * the skipped string, which is the entire tail if no match can be made.
   */
  Scanner.prototype.scanUntil = function (re) {
    var match, pos = this.tail.search(re);

    switch (pos) {
    case -1:
      match = this.tail;
      this.pos += this.tail.length;
      this.tail = "";
      break;
    case 0:
      match = "";
      break;
    default:
      match = this.tail.substring(0, pos);
      this.tail = this.tail.substring(pos);
      this.pos += pos;
    }

    return match;
  };

  function Context(view, parent) {
    this.view = view;
    this.parent = parent;
    this._cache = {};
  }

  Context.make = function (view) {
    return (view instanceof Context) ? view : new Context(view);
  };

  Context.prototype.push = function (view) {
    return new Context(view, this);
  };

  Context.prototype.lookup = function (name) {
    var value = this._cache[name];

    if (!value) {
      if (name == '.') {
        value = this.view;
      } else {
        var context = this;

        while (context) {
          if (name.indexOf('.') > 0) {
            value = context.view;
            var names = name.split('.'), i = 0;
            while (value && i < names.length) {
              value = value[names[i++]];
            }
          } else {
            value = context.view[name];
          }

          if (value != null) break;

          context = context.parent;
        }
      }

      this._cache[name] = value;
    }

    if (typeof value === 'function') value = value.call(this.view);

    return value;
  };

  function Writer() {
    this.clearCache();
  }

  Writer.prototype.clearCache = function () {
    this._cache = {};
    this._partialCache = {};
  };

  Writer.prototype.compile = function (template, tags) {
    var fn = this._cache[template];

    if (!fn) {
      var tokens = exports.parse(template, tags);
      fn = this._cache[template] = this.compileTokens(tokens, template);
    }

    return fn;
  };

  Writer.prototype.compilePartial = function (name, template, tags) {
    var fn = this.compile(template, tags);
    this._partialCache[name] = fn;
    return fn;
  };

  Writer.prototype.getPartial = function (name) {
    if (!(name in this._partialCache) && this._loadPartial) {
      this.compilePartial(name, this._loadPartial(name));
    }

    return this._partialCache[name];
  };

  Writer.prototype.compileTokens = function (tokens, template) {
    var self = this;
    return function (view, partials) {
      if (partials) {
        if (typeof partials === 'function') {
          self._loadPartial = partials;
        } else {
          for (var name in partials) {
            self.compilePartial(name, partials[name]);
          }
        }
      }

      return renderTokens(tokens, self, Context.make(view), template);
    };
  };

  Writer.prototype.render = function (template, view, partials) {
    return this.compile(template)(view, partials);
  };

  /**
   * Low-level function that renders the given `tokens` using the given `writer`
   * and `context`. The `template` string is only needed for templates that use
   * higher-order sections to extract the portion of the original template that
   * was contained in that section.
   */
  function renderTokens(tokens, writer, context, template) {
    var buffer = '';

    var token, tokenValue, value;
    for (var i = 0, len = tokens.length; i < len; ++i) {
      token = tokens[i];
      tokenValue = token[1];

      switch (token[0]) {
      case '#':
        value = context.lookup(tokenValue);

        if (typeof value === 'object') {
          if (isArray(value)) {
            for (var j = 0, jlen = value.length; j < jlen; ++j) {
              buffer += renderTokens(token[4], writer, context.push(value[j]), template);
            }
          } else if (value) {
            buffer += renderTokens(token[4], writer, context.push(value), template);
          }
        } else if (typeof value === 'function') {
          var text = template == null ? null : template.slice(token[3], token[5]);
          value = value.call(context.view, text, function (template) {
            return writer.render(template, context);
          });
          if (value != null) buffer += value;
        } else if (value) {
          buffer += renderTokens(token[4], writer, context, template);
        }

        break;
      case '^':
        value = context.lookup(tokenValue);

        // Use JavaScript's definition of falsy. Include empty arrays.
        // See https://github.com/janl/mustache.js/issues/186
        if (!value || (isArray(value) && value.length === 0)) {
          buffer += renderTokens(token[4], writer, context, template);
        }

        break;
      case '>':
        value = writer.getPartial(tokenValue);
        if (typeof value === 'function') buffer += value(context);
        break;
      case '&':
        value = context.lookup(tokenValue);
        if (value != null) buffer += value;
        break;
      case 'name':
        value = context.lookup(tokenValue);
        if (value != null) buffer += exports.escape(value);
        break;
      case 'text':
        buffer += tokenValue;
        break;
      }
    }

    return buffer;
  }

  /**
   * Forms the given array of `tokens` into a nested tree structure where
   * tokens that represent a section have two additional items: 1) an array of
   * all tokens that appear in that section and 2) the index in the original
   * template that represents the end of that section.
   */
  function nestTokens(tokens) {
    var tree = [];
    var collector = tree;
    var sections = [];

    var token;
    for (var i = 0, len = tokens.length; i < len; ++i) {
      token = tokens[i];
      switch (token[0]) {
      case '#':
      case '^':
        sections.push(token);
        collector.push(token);
        collector = token[4] = [];
        break;
      case '/':
        var section = sections.pop();
        section[5] = token[2];
        collector = sections.length > 0 ? sections[sections.length - 1][4] : tree;
        break;
      default:
        collector.push(token);
      }
    }

    return tree;
  }

  /**
   * Combines the values of consecutive text tokens in the given `tokens` array
   * to a single token.
   */
  function squashTokens(tokens) {
    var squashedTokens = [];

    var token, lastToken;
    for (var i = 0, len = tokens.length; i < len; ++i) {
      token = tokens[i];
      if (token) {
        if (token[0] === 'text' && lastToken && lastToken[0] === 'text') {
          lastToken[1] += token[1];
          lastToken[3] = token[3];
        } else {
          lastToken = token;
          squashedTokens.push(token);
        }
      }
    }

    return squashedTokens;
  }

  function escapeTags(tags) {
    return [
      new RegExp(escapeRe(tags[0]) + "\\s*"),
      new RegExp("\\s*" + escapeRe(tags[1]))
    ];
  }

  /**
   * Breaks up the given `template` string into a tree of token objects. If
   * `tags` is given here it must be an array with two string values: the
   * opening and closing tags used in the template (e.g. ["<%", "%>"]). Of
   * course, the default is to use mustaches (i.e. Mustache.tags).
   */
  exports.parse = function (template, tags) {
    template = template || '';
    tags = tags || exports.tags;

    if (typeof tags === 'string') tags = tags.split(spaceRe);
    if (tags.length !== 2) throw new Error('Invalid tags: ' + tags.join(', '));

    var tagRes = escapeTags(tags);
    var scanner = new Scanner(template);

    var sections = [];     // Stack to hold section tokens
    var tokens = [];       // Buffer to hold the tokens
    var spaces = [];       // Indices of whitespace tokens on the current line
    var hasTag = false;    // Is there a {{tag}} on the current line?
    var nonSpace = false;  // Is there a non-space char on the current line?

    // Strips all whitespace tokens array for the current line
    // if there was a {{#tag}} on it and otherwise only space.
    function stripSpace() {
      if (hasTag && !nonSpace) {
        while (spaces.length) {
          delete tokens[spaces.pop()];
        }
      } else {
        spaces = [];
      }

      hasTag = false;
      nonSpace = false;
    }

    var start, type, value, chr, token;
    while (!scanner.eos()) {
      start = scanner.pos;

      // Match any text between tags.
      value = scanner.scanUntil(tagRes[0]);
      if (value) {
        for (var i = 0, len = value.length; i < len; ++i) {
          chr = value.charAt(i);

          if (isWhitespace(chr)) {
            spaces.push(tokens.length);
          } else {
            nonSpace = true;
          }

          tokens.push(['text', chr, start, start + 1]);
          start += 1;

          // Check for whitespace on the current line.
          if (chr == '\n') stripSpace();
        }
      }

      // Match the opening tag.
      if (!scanner.scan(tagRes[0])) break;
      hasTag = true;

      // Get the tag type.
      type = scanner.scan(tagRe) || 'name';
      scanner.scan(whiteRe);

      // Get the tag value.
      if (type === '=') {
        value = scanner.scanUntil(eqRe);
        scanner.scan(eqRe);
        scanner.scanUntil(tagRes[1]);
      } else if (type === '{') {
        value = scanner.scanUntil(new RegExp('\\s*' + escapeRe('}' + tags[1])));
        scanner.scan(curlyRe);
        scanner.scanUntil(tagRes[1]);
        type = '&';
      } else {
        value = scanner.scanUntil(tagRes[1]);
      }

      // Match the closing tag.
      if (!scanner.scan(tagRes[1])) throw new Error('Unclosed tag at ' + scanner.pos);

      token = [type, value, start, scanner.pos];
      tokens.push(token);

      if (type === '#' || type === '^') {
        sections.push(token);
      } else if (type === '/') {
        // Check section nesting.
        if (sections.length === 0) throw new Error('Unopened section "' + value + '" at ' + start);
        var openSection = sections.pop();
        if (openSection[1] !== value) throw new Error('Unclosed section "' + openSection[1] + '" at ' + start);
      } else if (type === 'name' || type === '{' || type === '&') {
        nonSpace = true;
      } else if (type === '=') {
        // Set the tags for the next time around.
        tags = value.split(spaceRe);
        if (tags.length !== 2) throw new Error('Invalid tags at ' + start + ': ' + tags.join(', '));
        tagRes = escapeTags(tags);
      }
    }

    // Make sure there are no open sections when we're done.
    var openSection = sections.pop();
    if (openSection) throw new Error('Unclosed section "' + openSection[1] + '" at ' + scanner.pos);

    tokens = squashTokens(tokens);

    return nestTokens(tokens);
  };

  // All Mustache.* functions use this writer.
  var _writer = new Writer();

  /**
   * Clears all cached templates and partials in the default writer.
   */
  exports.clearCache = function () {
    return _writer.clearCache();
  };

  /**
   * Compiles the given `template` to a reusable function using the default
   * writer.
   */
  exports.compile = function (template, tags) {
    return _writer.compile(template, tags);
  };

  /**
   * Compiles the partial with the given `name` and `template` to a reusable
   * function using the default writer.
   */
  exports.compilePartial = function (name, template, tags) {
    return _writer.compilePartial(name, template, tags);
  };

  /**
   * Compiles the given array of tokens (the output of a parse) to a reusable
   * function using the default writer.
   */
  exports.compileTokens = function (tokens, template) {
    return _writer.compileTokens(tokens, template);
  };

  /**
   * Renders the `template` with the given `view` and `partials` using the
   * default writer.
   */
  exports.render = function (template, view, partials) {
    return _writer.render(template, view, partials);
  };

  // This is here for backwards compatibility with 0.4.x.
  exports.to_html = function (template, view, partials, send) {
    var result = exports.render(template, view, partials);

    if (typeof send === "function") {
      send(result);
    } else {
      return result;
    }
  };

});


/**
 * @fileoverview 包装为延迟触发的函数
 * @authors liangdong2 <liangdong2@staff.sina.com.cn>
 * @param {Function} fn 要延迟触发的函数
 * @param {Number} delay 延迟时间[ms]
 * @param {Object} bind 函数的this指向
 * @example
	var comp = {
		countWords : function(){
			console.debug(this.length);
		}
	};
	$('#input').keydown($delay(function(){
		this.length = $('#input').val().length;
		this.countWords();
	}, 200, comp));
 */
define('lib/kit/func/delay',function(require,exports,module){

	module.exports = function(fn, delay, bind){
		var timer = null;
		return function(){
			bind = bind || this;
			if(timer)clearTimeout(timer);
			var args = arguments;
			timer = setTimeout(function(){
				fn.apply(bind, args);
			}, delay);
		};
	};
});


;(function(){
	//自定义log组件，用于客户端调试

	var elLog;
	var inited = false;
	var cache = [];

	window.log = function(){
		var info = Array.prototype.slice.call(arguments).join(' ');
		var p;
		if(inited){
			p = document.createElement('p');
			p.innerHTML = info;
			elLog.appendChild(p);
			elLog.style.display = '';
		}else{
			cache.push(info);
		}
	};

	setTimeout(function(){
		var cacheInfos = cache.map(function(str){
			return '<p>' + str + '</p>';
		}).join('');
		if(!elLog){
			elLog = document.createElement('div');
			elLog.style.cssText = [
				'display:none;',
				'position:fixed;',
				'bottom:60px;',
				'width:100%;',
				'max-height:200px;',
				'overflow:auto;',
				'-webkit-overflow-scrolling:touch;',
				'background:rgba(0,0,0,0.5);',
				'color:#fff;',
				'font-size:9px;',
				'word-wrap: break-word;',
				'word-break: break-all;',
				'z-index: 9999;'
			].join('');
			document.body.appendChild(elLog);
		}
		if(cacheInfos){
			elLog.innerHTML = cacheInfos;
			elLog.style.display = '';
		}

		inited = true;
	}, 500);

})();


/**
 * @fileoverview 正文组件化
 * @authors yifei2 <yifei2@staff.sina.com.cn>
 */
define('conf/page/compindex',function(require,exports,module){

	require('conf/global');

	var uiButton = require('mods/ui/button');
	var uiLink = require('mods/ui/link');
	var uiImgbox = require('mods/ui/imgbox');
	var uiImgsbox = require('mods/ui/imgsbox');
	var uiSlides = require('mods/ui/slides');
	var uiHdSlide = require('mods/ui/hdSlides');
	var uiTextlimit = require('mods/ui/textlimit');

	var compRender = require('mods/comp/render');
	var compAudio = require('mods/comp/audio');
	var compCommmon = require('mods/comp/common');
	var compRSS = require('mods/comp/mediaSpread');
	var compVotes = require('mods/comp/votes');
	//var compTopScale = require('mods/comp/topScale');
	//var appConsole = require('mods/comp/console');
	var compCommentLike = require('mods/comp/commentLike');
	var compCommentFloor = require('mods/comp/commentFloor');
	var compGifLoad = require('mods/ui/gifLoad');
	var compDigger = require('mods/comp/digger');
	var compShare = require('mods/comp/shareEntry');
	var compMoreRecommend = require('mods/comp/loadRecommend');
	var compISupport = require('mods/comp/iSupport');

	uiButton.init();
	uiLink.init();
	uiImgbox.init({
		styleErrorTooSmall : 'C_downloadsmaller',
		styleErrorSmall : 'C_downloadsmall',
		styleError : 'C_download',
		styleLoading : 'C_loading'
	});
  uiImgsbox.init({
		styleErrorTooSmall : 'C_downloadsmaller',
		styleErrorSmall : 'C_downloadsmall',
		styleError : 'C_download',
		styleLoading : 'C_loading'
	});

	uiSlides.init();
	uiHdSlide.init();
	uiTextlimit.init();

	compRender.init();
	compAudio.init();
	compVotes.init();
	compCommmon.init();
	compRSS.init();
	//compTopScale.init();
	compCommentLike.init();
	compCommentFloor.init();
	compGifLoad.init();
	compMoreRecommend.init();
	compISupport.init();
	compDigger.init();
    //appConsole.init();
});


