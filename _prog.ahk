; =====================================================================================
; Prog(fontFace := 'Segoe UI', fontSize := 8, cancel_text := 'Cancel', range:='0-100')
;
;   Usage:
;
;       Define fontFace and fontSize as desired.  You can also customize the
;       Cancel button text.  The intent is to always have a Cancel button.  Lastly,
;       you can also set the range on creation.
;
;       All updates to the UI are meant to be done with the properties and methods.
;       Invoking the function will destroy the old UI and create a new one, but the
;       old one will still remain, unless you call the Close() method.
;
;       For all other intents and purposes, this class is an extension of the Gui
;       object.  So you can position it and customize other things by using the
;       methods and properties of a typical Gui object.
;
;   Properties:
;
;       obj.Range (str)
;
;           Get or set a str that represents the range (#-#, ie. "0-100").
;
;       obj.Value (integer)
;
;           Get or set the Value of the progress bar.
;
;       obj.Text1 (str)
;
;           Get or set the text above the progress bar.
;
;       obj.Text2 (str)
;
;           Get or set the text below the progress bar.
;
;       obj.Title (str)
;
;           Get or set the window title.
;
;   Methods:
;
;       obj.Update(prog, txt1, txt2)
;
;           All parameters are opitonal.
;           prog := integer, the progressbar value
;           txt1 := str, the text above the progress bar
;           txt2 := str, the text below the progress bar
;
;       obj.Close()
;
;           Closes the gui.  When the gui is closed the object and it's references
;           are destroyed as well.  If you are concerned about reference counting,
;           you can verify object deletion by adding the following method:
;
;               __Delete() => Msgbox('bye bye')
;
; =====================================================================================

class Prog extends Gui {
    Abort := false, Visible := true, _range_ := '0-100'
    
    __New(fontFace := 'Segoe UI', fontSize := 8, cancel_text := 'Cancel', range:='0-100') {
        super.__New('-MinimizeBox -MaximizeBox',,this)
        this.OnEvent('Close',(*) => (this.Close()))
        this.SetFont('s' fontSize, fontFace)
        t1 := this.Add('Text','xm w10 vText1','')
        p := this.Add('Progress','xm w10 vProg',0)
        t2 := this.Add('Text','xm w10 vText2','')
        txt := this.Add('Text','xm Hidden cRed vCancelNotify','Cancel pending...'), txt.GetPos(&tX,,&tW)
        
        this.DefineProp('Cancel',{Call:(ctl,info) => (ctl.gui.Abort := true, ctl.gui['CancelNotify'].Visible := true)})
        this.DefineProp('Range',{Get:(*) => this._range_, Set:(o,Value) => this['Prog'].Opt('Range' Value)})
        this.DefineProp('Text1',{Get:(*) => this['Text1'].Text, Set:(o,Value) => this['Text1'].Text := Value})
        this.DefineProp('Text2',{Get:(*) => this['Text2'].Text, Set:(o,Value) => this['Text2'].Text := Value})
        this.DefineProp('Value',{Get:(*) => this['Prog'].Value, Set:(o,Value) => this['Prog'].Value := Value})
        this.DefineProp('Cleanup',{Call:(*) => (dp('Cancel'),dp('Range'),dp('Text1'),dp('Text2'),dp('Value'))})
        
        btn := this.Add('Button','x+' (tX+tW) ' yp-4 vCancel',cancel_text), btn.OnEvent('click',this.Cancel), btn.GetPos(&bX,,&bW)
        t1.Move(,,w:=tX+tW+tW+bW), p.Move(,,w), t2.Move(,,w)
        
        this.Range := range, this.Show()
        dp(_in_) => this.DeleteProp(_in_)
    }
    
    Close() => (this.Cleanup(), this.DeleteProp('Cleanup'), this.Visible := false, this.Destroy()) ; properly discard references
    
    Update(prog:=unset, txt1:=unset, txt2:=unset) =>
        ((IsSet(prog) ? this.Value := prog : ''), (IsSet(txt1) ? this.Text1 := txt1 : ''), (IsSet(txt2) ? this.Text2 := txt2 : ''))
}