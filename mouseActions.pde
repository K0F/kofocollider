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



/*
   void mousePressed(){
   editors.add(new Editor("syn"+editors.size(),mouseX,mouseY));
   currEdit = editors.size()-1;
   }

   void mouseDragged(){
   println("starting recording of envelope");
   Editor tmp = (Editor)editors.get(currEdit);
   Envelope tenv = (Envelope)tmp.envelopes.get(tmp.envelopes.size()-1);
   tenv.recording = true;
   }

   void mouseReleased(){
   Editor tmp = (Editor)editors.get(currEdit);
   Envelope tenv = (Envelope)tmp.envelopes.get(tmp.envelopes.size()-1);

   try{
   tenv.recording = false;
   tenv.recorded = true;

   }catch(Exception e){
   println("envelope creation err");
   }
   }


 */


void mousePressed(){
  for(int i = 0 ; i < envelopes.size();i++){
    Envelope en  =(Envelope)envelopes.get(i);
    if(en.over){
      en.recording = true;
      en.vals = new ArrayList();
    }

    if(en.outOver()){
      last = new Connection(en);
      connections.add(last);
    }
  }

  if(mouseButton==RIGHT){
    editor.add(new Editor("syn"+editors.size(),mouseX,mouseY));
  }
}

void mouseReleased(){

  for(int i = 0 ; i < envelopes.size();i++){
    Envelope en  =(Envelope)envelopes.get(i);
    en.recording = false;
  }

  try{
    if(last!=null && !last.done)
      for(int i = 0 ; i < editors.size();i++){
        Editor ed = (Editor)editors.get(i);
        int field = ed.fieldOver();
        if(field>-1){
          println("detected field over "+ed.fieldOver());
          if(!last.done)
            last.connectTo(ed,field);
        }
      }
  }catch(Exception e){
    println("connection err "+e);
  };
}

