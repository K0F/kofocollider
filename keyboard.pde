/*

   Kofocollider interface to SuperCollider written in processing and using OpenObject
   Copyright (C) 2015 Krystof Pesek

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


void keyPressed(){
  Editor editor = (Editor)editors.get(currEdit);

  try{

    if(keyCode==TAB){
      currEdit++;
      currEdit=currEdit%editors.size();
    }

    if(keyCode==17){
      editor.execute=true;
    }

    if(keyCode==ENTER){

      String tmp = (String)editor.lines.get(editor.currln);
      editor.lines.set(editor.currln,tmp.substring(0,editor.carret));
      editor.lines.add(editor.currln+1,"");
      editor.currln++;
      editor.lines.set(editor.currln,tmp.substring(editor.carret,tmp.length()));
      editor.carret=0;
    }

    if(keyCode==LEFT)
      editor.carret--;

    if(keyCode==RIGHT)
      editor.carret++;

    if(keyCode==DOWN){
      editor.currln++;
      editor.currln=constrain(editor.currln,0,editor.lines.size()-1);
    }

    if(keyCode==UP){
      if(editor.currln>0)
        editor.currln--;
      editor.currln=constrain(editor.currln,0,editor.lines.size()-1);
    }

    if(keyCode==BACKSPACE && editor.carret>0){
      String tmp = (String)editor.lines.get(editor.currln);
      if(tmp.length()>0){
        editor.lines.set(editor.currln,tmp.substring(0,editor.carret-1)+""+tmp.substring(editor.carret,tmp.length()));
        editor.carret--;
      }
    }else if(keyCode==BACKSPACE && editor.carret==0 && editor.currln>0){
      String tmp = (String)editor.lines.get(editor.currln);
      String pre = (String)editor.lines.get(editor.currln-1);
      editor.lines.set(editor.currln-1,pre+tmp.substring(editor.carret,tmp.length()));
      editor.carret = pre.length();
      editor.currln--;
      editor.lines.remove(editor.currln+1);
    }


    if(keyCode==DELETE){
      String tmp = (String)editor.lines.get(editor.currln);
      if(tmp.length()>0){
        editor.lines.set(editor.currln,tmp.substring(0,editor.carret)+""+tmp.substring(editor.carret+1,tmp.length()));
        editor.carret--;
      }else if(tmp.length()==editor.carret && editor.lines.size()>editor.currln){
        String post = (String)editor.lines.get(editor.currln+1);
        editor.lines.set(editor.currln,tmp.substring(0,editor.carret)+""+post);
        editor.lines.remove(editor.currln+1);
      }
    } 

    if((int)key>=24 && (int)key <= 126){
      try{
        String tmp = (String)editor.lines.get(editor.currln);
        editor.lines.set(editor.currln,tmp.substring(0,editor.carret)+""+key+tmp.substring(editor.carret,tmp.length()));
        editor.carret++;
      }catch(Exception e){
        println("async key "+key);
      }
    }else{
      println((int)key);
    }


    editor.carret = constrain(editor.carret,0,((String)editor.lines.get(editor.currln)).length());
    editor.currln = constrain(editor.currln,0,editor.lines.size()-1);

  }catch(Exception e){
    println("some key error!");
  }
}

