package haxe.ui.components;
import haxe.ui.containers.ListView;
import haxe.ui.core.Component;
import haxe.ui.core.IClonable;
import haxe.ui.core.IDataComponent;
import haxe.ui.core.ItemRenderer;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.Screen;
import haxe.ui.core.UIEvent;

class DropDown extends Button implements IDataComponent implements IClonable<DropDown> {
    private var _listview:ListView;
    private var _itemRenderer:ItemRenderer;

    public function new() {
        super();
        addClass("button"); // TODO: shouldnt have to do this
        toggle = true;
        registerEvent(MouseEvent.CLICK, onMouseClick);
    }

    private var _data:Dynamic;
    public var data(get, set):Dynamic;
    private function get_data():Dynamic {
        return null;
    }
    private function set_data(value:Dynamic):Dynamic {
        _data = value;
        return value;
    }

    private var _listWidth:Null<Float>;
    public var listWidth(get, set):Null<Float>;
    private function get_listWidth():Null<Float> {
        return _listWidth;
    }
    private function set_listWidth(value:Null<Float>):Null<Float> {
        _listWidth = value;
        return value;
    }

    private var _listHeight:Null<Float>;
    public var listHeight(get, set):Null<Float>;
    private function get_listHeight():Null<Float> {
        return _listHeight;
    }
    private function set_listHeight(value:Null<Float>):Null<Float> {
        _listHeight = value;
        return value;
    }

    private var _listSize:Int = 4;
    public var listSize(get, set):Int;
    private function get_listSize():Int {
        return _listSize;
    }
    private function set_listSize(value:Int):Int {
        _listSize = value;
        return value;
    }

    private var _listStyleNames:String;
    public var listStyleNames(get, set):String;
    private function get_listStyleNames():String {
        return _listStyleNames;
    }
    private function set_listStyleNames(value:String):String {
        _listStyleNames = value;
        return value;
    }

    public override function addComponent(child:Component):Component {
        var r = null;
        if (Std.is(child, ItemRenderer) && _itemRenderer == null) {
            _itemRenderer = cast(child, ItemRenderer);
            #if haxeui_luxe
            _itemRenderer.hide();
            #end
        } else {
            r = super.addComponent(child);
        }
        return r;
    }
    
    private function onMouseClick(event:MouseEvent) {
        if (selected == true) {
            if (_listview == null) {
                _listview = new ListView();
                if (_itemRenderer != null) {
                    _listview.addComponent(_itemRenderer);
                }
                _listview.addClass("popup");
                if (_listStyleNames != null) {
                    for (s in _listStyleNames.split(" ")) {
                        _listview.addClass(s);
                    }
                }
                if (_data != null) {
                    _listview.data = _data;
                }
                _listview.registerEvent(UIEvent.CHANGE, onItemChange);
            }
            Screen.instance.addComponent(_listview);

            _listview.left = this.screenLeft;
            _listview.top = this.screenTop + this.componentHeight;
            if (_listWidth == null) {
                _listview.width = Math.ffloor(this.componentWidth);
            } else {
                _listview.width = _listWidth;
            }

            var listHeight = _listHeight;
            if (_listHeight == null) {
                var n:Int = _listSize;
                if (n > _listview.itemCount) {
                    n = _listview.itemCount;
                }
                listHeight = n * _listview.itemHeight + (_listview.layout.paddingTop + _listview.layout.paddingBottom);
            }
            _listview.height = listHeight;
            
            if (_listview.screenTop + _listview.height > Screen.instance.height) {
                _listview.y = this.screenTop - _listview.height;
            }
            
            

            Screen.instance.registerEvent(MouseEvent.MOUSE_DOWN, onScreenMouseDown);
        } else {
            if (_listview != null) {
                Screen.instance.removeComponent(_listview);
            }
            Screen.instance.unregisterEvent(MouseEvent.MOUSE_DOWN, onScreenMouseDown);
        }
    }

    private function onItemChange(event:UIEvent) {
        if (_listview.selectedItem.data.text != null) {
            this.text = _listview.selectedItem.data.text;
        }
        selected = false;
        onMouseClick(null);
    }

    private function onScreenMouseDown(event:MouseEvent) {
        if (hitTest(event.screenX, event.screenY) == true) {
            return;
        }
        if (_listview != null && _listview.hitTest(event.screenX, event.screenY) == true) {
            return;
        }
        selected = !selected;
        onMouseClick(null);
    }

}

