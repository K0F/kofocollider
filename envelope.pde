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



class Envelope{

  ArrayList vals;
  int pointer = 0;
  String name;
  PVector pos;
  int ctlId;
  float output;

  boolean recorded;
  boolean recording;

  PVector dim;

  boolean over;

  ArrayList connections;

  Envelope(float _x,float _y){
    vals = new ArrayList();

    pos = new PVector(_x,_y);
    dim = new PVector(200,75);

    pointer = 0;
    println("casting envelope: "+ name);

    connections = new ArrayList();
  }

  void record(){
    if(recording)
      vals.add(constrain(map(mouseY,pos.y,pos.y+dim.y,0,1),0.001,1));

  }

  boolean over(){
    if(mouseX>pos.x&&mouseX<pos.x+dim.x&&mouseY>pos.y&&mouseY<pos.y+dim.y)
      return true;
    else
      return false;
  }

  boolean outOver(){
    if(mouseX>pos.x&&mouseX<pos.x+10&&mouseY>pos.y+dim.y&&mouseY<pos.y+dim.y+10)
      return true;
    else
      return false;
  }


  void draw(){

    over = over();

    record();

    fill(25);
    stroke(255);
    rect(pos.x,pos.y,dim.x,dim.y);

    if(vals.size()>0){
      /*
         vals.add(noise((frameCount+(editors.indexOf(parent)*1000.0))/(100.0*(ctlId+1.0))) );
       */

      if(!recording){
        float first = (Float)vals.get(0);
        vals.remove(0);
        vals.add(first);
      }

      pushMatrix();
      translate(pos.x,pos.y);
      noFill();
      stroke(255);
      beginShape();
      for(int i = 0 ; i< vals.size();i++){
        Float tmp = (Float)vals.get(i);
        vertex(map(i,0,vals.size(),0,dim.x),tmp*dim.y);
      }
      endShape();

      output = 1.0 - (Float)vals.get(vals.size()-1) + 0.001;
      fill(output*255);
      rect(0,dim.y,10,10);
      popMatrix();

    }
  }
}
