package fairygui
{	
	public class GProgressBar extends GComponent
	{
		private var _max:int;
		private var _value:int;
		private var _titleType:int;
		private var _reverse:Boolean;
		
		private var _titleObject:GTextField;
		private var _aniObject:GObject;
		private var _barObjectH:GObject;
		private var _barObjectV:GObject;
		private var _barMaxWidth:int;
		private var _barMaxHeight:int;
		private var _barMaxWidthDelta:int;
		private var _barMaxHeightDelta:int;
		private var _barStartX:int;
		private var _barStartY:int;
		
		public function GProgressBar()
		{
			super();
			
			_titleType = ProgressTitleType.Percent;
			_value = 50;
			_max = 100;
		}

		final public function get titleType():int
		{
			return _titleType;
		}

		final public function set titleType(value:int):void
		{
			_titleType = value;
		}

		final public function get max():int
		{
			return _max;
		}

		final public function set max(value:int):void
		{
			if(_max != value)
			{
				_max = value;
				update();
			}
		}

		final public function get value():int
		{
			return _value;
		}
		
		final public function set value(value:int):void
		{
			if(_value != value)
			{
				_value = value;
				update();
			}
		}
		
		public function update():void
		{
			var percent:Number = Math.min(_value/_max,1);
			if(_titleObject)
			{
				switch(_titleType)
				{
					case ProgressTitleType.Percent:
						_titleObject.text = Math.round(percent*100)+"%";
						break;
					
					case ProgressTitleType.ValueAndMax:
						_titleObject.text = _value + "/" + _max;
						break;
					
					case ProgressTitleType.Value:
						_titleObject.text = ""+_value;
						break;
					
					case ProgressTitleType.Max:
						_titleObject.text = ""+_max;
						break;
				}
			}
			
			var fullWidth:int = this.width-this._barMaxWidthDelta;
			var fullHeight:int = this.height-this._barMaxHeightDelta;
			if(!_reverse)
			{
				if(_barObjectH)
					_barObjectH.width = fullWidth*percent;
				if(_barObjectV)
					_barObjectV.height = fullHeight*percent;
			}
			else
			{
				if(_barObjectH)
				{
					_barObjectH.width = fullWidth*percent;
					_barObjectH.x = _barStartX + (fullWidth-_barObjectH.width);
					
				}
				if(_barObjectV)
				{
					_barObjectV.height = fullHeight*percent;
					_barObjectV.y =  _barStartY + (fullHeight-_barObjectV.height);
				}
			}
			if(_aniObject is GMovieClip)
				GMovieClip(_aniObject).frame = Math.round(percent*100);
			else if(_aniObject is GSwfObject)
				GSwfObject(_aniObject).frame = Math.round(percent*100);
		}
		
		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			
			xml = xml.ProgressBar[0];
			
			var str:String;
			str = xml.@titleType;
			if(str)
				_titleType = ProgressTitleType.parse(str);

			_reverse = xml.@reverse=="true";
			
			_titleObject = getChild("title") as GTextField;
			_barObjectH = getChild("bar");
			_barObjectV = getChild("bar_v");
			_aniObject = getChild("ani");
			
			if(_barObjectH)
			{
				_barMaxWidth = _barObjectH.width;
				_barMaxWidthDelta = this.width - _barMaxWidth;
				_barStartX = _barObjectH.x;
			}
			if(_barObjectV)
			{
				_barMaxHeight = _barObjectV.height;
				_barMaxHeightDelta = this.height - _barMaxHeight;
				_barStartY = _barObjectV.y;
			}
		}
		
		override protected function handleSizeChanged():void
		{
			super.handleSizeChanged();
			
			if(_barObjectH)
				_barMaxWidth = this.width - _barMaxWidthDelta;
			if(_barObjectV)
				_barMaxHeight = this.height - _barMaxHeightDelta;
			if(!this._underConstruct)
				update();
		}
		
		override public function setup_afterAdd(xml:XML):void
		{
			super.setup_afterAdd(xml);
			
			xml = xml.ProgressBar[0];
			if(xml)
			{
				_value = parseInt(xml.@value);
				_max = parseInt(xml.@max);
			}
			update();
		}
	}
}