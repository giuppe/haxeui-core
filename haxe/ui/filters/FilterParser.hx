package haxe.ui.filters;

class FilterParser {
    private static var filterParamDefaults:Map<String, Array<Dynamic>>;

    public static function parseFilter(filterDetails:Array<Dynamic>):Filter {
        var filter:Filter = null;
        if (filterDetails[0] == "drop-shadow") {
            filter = parseDropShadow(filterDetails);
        } else if (filterDetails[0] == "box-shadow") {
            filter = parseBoxShadow(filterDetails);
        } else if (filterDetails[0] == "blur") {
            filter = parseBlur(filterDetails);
        } else if (filterDetails[0] == "outline") {
            filter = parseOutline(filterDetails);
        } else if (filterDetails[0] == "grayscale") {
            filter = parseGrayscale(filterDetails);
        }
        return filter;
    }

    public static function parseDropShadow(filterDetails:Array<Dynamic>):DropShadow {
        if (filterDetails == null || filterDetails.length == 0) {
            return null;
        }

        var copy:Array<Dynamic> = filterDetails.copy();
        buildDefaults();

        var filterName = copy[0];
        copy.remove(filterName);

        copy = copyFilterDefaults(filterName, copy);

        var dropShadow:DropShadow = new DropShadow();
        dropShadow.distance = copy[0];
        dropShadow.angle = copy[1];
        dropShadow.color = copy[2];
        dropShadow.alpha = copy[3];
        dropShadow.blurX = copy[4];
        dropShadow.blurY = copy[5];
        dropShadow.strength = copy[6];
        dropShadow.quality = copy[7];
        dropShadow.inner = copy[8];
        return dropShadow;
    }

    public static function parseBoxShadow(filterDetails:Array<Dynamic>):BoxShadow {
        if (filterDetails == null || filterDetails.length == 0) {
            return null;
        }

        var copy:Array<Dynamic> = filterDetails.copy();
        buildDefaults();

        var filterName = copy[0];
        copy.remove(filterName);

        copy = copyFilterDefaults(filterName, copy);

        var boxShadow:BoxShadow = new BoxShadow();
        boxShadow.offsetX = copy[0];
        boxShadow.offsetY = copy[1];
        boxShadow.color = copy[2];
        boxShadow.alpha = copy[3];
        boxShadow.blurRadius = copy[4];
        boxShadow.spreadRadius = copy[5];
        boxShadow.inset = copy[6];
        return boxShadow;
    }

    public static function parseBlur(filterDetails:Array<Dynamic>):Blur {
        if (filterDetails == null || filterDetails.length == 0) {
            return null;
        }

        var copy:Array<Dynamic> = filterDetails.copy();
        buildDefaults();

        var filterName = copy[0];
        copy.remove(filterName);

        copy = copyFilterDefaults(filterName, copy);

        var blur:Blur = new Blur();
        blur.amount = copy[0];
        return blur;
    }

    public static function parseOutline(filterDetails:Array<Dynamic>):Outline {
        if (filterDetails == null || filterDetails.length == 0) {
            return null;
        }

        var copy:Array<Dynamic> = filterDetails.copy();
        buildDefaults();

        var filterName = copy[0];
        copy.remove(filterName);

        copy = copyFilterDefaults(filterName, copy);

        var outline:Outline = new Outline();
        outline.color = copy[0];
        outline.size = copy[1];
        return outline;
    }

    private static function copyFilterDefaults(filterName:String, params:Array<Dynamic>):Array<Dynamic> {
        var copy:Array<Dynamic> = [];

        var defaultParams:Array<Dynamic> = filterParamDefaults[filterName];
        if (defaultParams != null) {
            for (p in defaultParams) {
                copy.push(p);
            }
        }
        if (params != null) {
            var n:Int = 0;
            for (p in params) {
                copy[n] = p;
                n++;
            }
        }

        return copy;
    }

    public static function parseGrayscale(filterDetails:Array<Dynamic>):Grayscale {
        if (filterDetails == null || filterDetails.length == 0) {
            return null;
        }

        var copy:Array<Dynamic> = filterDetails.copy();
        buildDefaults();

        var filterName = copy[0];
        copy.remove(filterName);

        copy = copyFilterDefaults(filterName, copy);

        var grayscale:Grayscale = new Grayscale();
        grayscale.amount = copy[0];
        return grayscale;
    }
    
    private static function buildDefaults() {
        if (filterParamDefaults != null) {
            return;
        }

        filterParamDefaults = new Map<String, Array<Dynamic>>();
        filterParamDefaults["drop-shadow"] = [];
        filterParamDefaults["drop-shadow"] = filterParamDefaults["drop-shadow"].concat([4, 45, 0, 1, 4, 4, 1, 1, false, false, false]);

        filterParamDefaults["box-shadow"] = [];
        filterParamDefaults["box-shadow"] = filterParamDefaults["box-shadow"].concat([2, 2, 0, .1, 1, 0, false]);

        filterParamDefaults["blur"] = [];
        filterParamDefaults["blur"] = filterParamDefaults["blur"].concat([1]);

        filterParamDefaults["outline"] = [];
        filterParamDefaults["outline"] = filterParamDefaults["outline"].concat([0, 1]);
        
        filterParamDefaults["grayscale"] = [];
        filterParamDefaults["grayscale"] = filterParamDefaults["grayscale"].concat([100]);

    }
}