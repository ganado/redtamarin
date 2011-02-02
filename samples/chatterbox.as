
var start:Number = getTimer();

var elapsed:Function = function():Number
{
    return Number((getTimer() - start)/1000).toFixed( 0 );
}

var every:Function = function( num:uint ):Boolean
{
    var laps:Number = elapsed();
    if( laps < num ) { return false; }
    return ((laps%num)+1) == 1;
}

var between:Function = function(low,high):uint
{
    return Math.floor(Math.random()*(1+high-low))+low;
}

var pad:Function = function( source:String, amount:int, char:String = " " ):String
{
    var left:Boolean  = amount >= 0 ;
    var width:int     = amount > 0 ? amount : -amount ;
    
    if( ( width < source.length ) || ( width == 0 ) )
    {
        return source;
    }
    
    if ( char == null )
    {
        char = " " ; // default
    }
    else if ( char.length > 1 )
    {
        char = char.charAt(0) ; //we want only 1 char
    }
    
    while( source.length != width )
    {
        if( left )
        {
            source = char + source;
        }
        else
        {
            source += char;
        }
    }
    
    return source;
}

var format:Function = function( pattern:String, ...args:Array ):String
{
    if( pattern == null || pattern == "" )
    {
        return "";
    }
    
    var formatted:String = pattern;
    var len:uint         = args.length;
    var words:Object     = {};
    
    if( (len == 1) && (args[0] is Array) )
    {
        args = args[0];
    }
    else if( args[0] is Array )
    {
        var a:Array = args[0];
        args.shift();
        args = a.concat( args );
    }
    else if( (args[0] is Object) && (String( args[0] ) == "[object Object]") )
    {
        words = args[0];
        if( len > 1 ) 
        { 
            args.shift(); 
        }
    }
    
    var search:RegExp = new RegExp( "{([a-z0-9,:\\-]*)}", "m" );
    var result:Object = search.exec( formatted );
    
    var part:String;
    var token:String;
    var c:String;
    
    var dirty:Boolean ;
    
    var padding:int = 0;
    
    var buffer:Array = [];
    
    while( result != null )
    {
        part = result[0];
        
        token = result[1] ;
        
        var pos:int = token.indexOf( "," );
        
        if( pos > 0 )
        {
            padding = Number( token.substr( pos + 1 ) );
            token   = token.substring( 0, pos );
        }
        
        c = token.charAt( 0 ) ;
        
        if( ("0" <= c) && (c <= "9") )
        {
            formatted = formatted.replace( part, pad( String( args[token] ) , padding ) );
        }
        else if( ( token == "" ) || ( token.indexOf( ":" ) > -1 ) ) // if the token is not valid
        {
            buffer.push( part );
            
            formatted = formatted.replace( new RegExp(part,"g"), "\uFFFC"+ ( buffer.length - 1 ) ) ;
            dirty     = true;
        }
        else if( ( "a" <= c ) && ( c <= "z" ) )
        {
            if( token in words || words.hasOwnProperty( token ) )
            {
                formatted = formatted.replace( new RegExp(part,"g"), pad( String(words[token]) , padding ) );
            }
        }
        else
        {
            throw new Error( "format failed, malformed token \"" + part + "\", can not start with \"" + c + "\"" ) ;
        }
        
        result = search.exec( formatted );
    }
    
    if( dirty )
    {
        var i:int;
        var bl:int = buffer.length ; 
        for( i = 0 ; i < bl ; i++ )
        {
            formatted = formatted.replace( new RegExp( "\uFFFC" + i , "g" ) , buffer[i] );
        }
    }
    
    return formatted;
}

var context:Function = function( obj:Object ):Object
{
        obj.time     = new Date();
        obj.ip       = Socket.localAddresses[ between(0, Socket.localAddresses.length-1) ];
        obj.stuff    = stuff[ between(0, stuff.length-1) ];
    return obj;
}

var chatter:Function = function():String
{
    var str:String = phrases[ between(0, phrases.length-1) ];
    return format( str, context( brain ) );
}


