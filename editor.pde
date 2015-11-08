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

////////////////////////////////////////////////////////////////

class Editor{
  ArrayList lines,pre,post;
  ArrayList envelopes;

  int currln = 0;
  int carret = 0;

  int rozpal = 11;
  PVector pos;
  PVector dimm;

  String [] args = {"freq","amp","dur","mod","x","y","z"};
  float [] vals = new float[args.length];
  float [] field_rozpal = new float[args.length];

  float fadetime = 2;
  boolean playing = true;

  float w =0,wc =0;
  boolean execute = false;
  float fade = 0;
  String name;
  boolean over = false;

  float HH = 0;
  float maxW = 0;

  Editor(String _name){
    name = _name+"";
    pos = new PVector(100,100);
    generate();
  }

  Editor(String _name,int _x,int _y){
    name = _name+"";
    pos = new PVector(_x,_y);
    generate();
  }

  void generate(){

    envelopes = new ArrayList();

    pre = new ArrayList();
    lines = new ArrayList();
    post = new ArrayList();

    //prepare arguments line
    String targs = "";

    /*
       for(int i = 0; i < args.length;i++){
       envelopes.add(new Envelope(this,args[i],i));

       if(i==args.length-1)
       targs+=args[i];
       else
       targs+=args[i]+",";
       }
     */

    pre.add("~"+name+".ar(2);");
    pre.add("~"+name+".fadeTime="+fadetime+";");
    pre.add("~"+name+".quant=2;");
    pre.add("~"+name+"={|"+targs+"|");

    lines.add("var sig = LFSaw.ar(43.2);");
    lines.add("Splay.ar(sig,0.5,0.2);");

    post.add("};");
    post.add("~"+name+".play;");
    post.add("~"+name+".publish(\\"+name+");");
  }

  boolean over(){
    if(mouseX>pos.x-20&&mouseY>pos.y-20-HH&&mouseX<pos.x+dimm.x+40&&mouseY<pos.y+dimm.y+20)
      return true;
    else
      return false;
  }

  void message(Object [] data){
    osc.send("/oo",data,sc);
  }

  void sendVals(){
    ArrayList arrr = new ArrayList();
    arrr.add((Object)name+"");
    arrr.add((Object)"set");


    for(int i = 0; i < args.length;i++){
      arrr.add((Object)args[i]);
      arrr.add((Object)vals[i]);
    }

    Object complete[] = new Object[arrr.size()];
    for(int i = 0; i < arrr.size();i++){
      complete[i] = (Object)arrr.get(i);
    }

    message(complete);

  }

  int fieldOver(){
    int answer = -1;
    float sh = -17;
    for(int i = 0; i<args.length;i++){
      float tw = textWidth(args[i]);
      boolean active = (mouseX>sh-3+pos.x&&mouseX<tw+4+sh-3+pos.x&&mouseY<pos.y-20&&mouseY>pos.y-20-16)?true:false;
      if(active)
        answer=i;
      field_rozpal[i] = sh;
      sh += tw+6;
    } 

    return answer;
  }

  void render(){
    sendVals();

    maxW=0;
    for(int i =0 ; i < lines.size();i++){
      String curr = (String)lines.get(i);
      maxW = max(maxW,textWidth(curr));
    }

    dimm = new PVector(maxW,lines.size()*rozpal);


    over = over();

    //if(over)
    //currEdit = editors.indexOf(this);

    try{
      //carret = constrain(carret,0,((String)lines.get(currln)).length()-1);

      fade += execute ? 255 : -15;
      fade = constrain(fade,0,255);

      pushMatrix();
      translate(pos.x,pos.y);
      rectMode(CORNER);

      if(currEdit==editors.indexOf(this)){
        stroke(#ffcc00);
      }else{
        stroke(255,127);

      }
      fill(255,15);
      rect(-20,-20-HH,dimm.x+40,dimm.y+20);

      noStroke();
      for(int i =0 ; i < lines.size();i++){
        String curr = (String)lines.get(i);
        fill(255);
        text(curr,0,i*rozpal);


        fill(#ffcc00,fade);
        rect(-20,-20-HH,dimm.x+40,dimm.y+20);
        //rect(-5,i*rozpal+2,w+5,-rozpal);

        if(i==currln && currEdit==editors.indexOf(this)){
          w = textWidth(curr);
          wc = textWidth(curr.substring(0,carret));



          fill(#ff0000,(sin(millis()/25.0)+1.0)/2*255);
          rect(wc-1,i*rozpal-9,2,12);


        }
      }

      fill(255,(sin(millis()/250.0)+1.0)/2*255);


      String nn = "~"+name+" ";
      while(textWidth(nn)<maxW)
      nn+="-";

      nn+="   V";

      text(nn,-17,-42);

      float sh = -17;
      for(int i = 0; i<args.length;i++){
        float tw = textWidth(args[i]);
        stroke(#ffcc00);

        tw = textWidth(args[i]);
        boolean active = (mouseX>sh-3+pos.x&&mouseX<tw+4+sh-3+pos.x&&mouseY<pos.y-20&&mouseY>pos.y-20-16)?true:false;

        if(active)
          fill(#ff1111);
        else
          fill(#ff1111,vals[i]*127);
        rect(sh-3,-20,tw+4,-16);

        /* 
           if(active && mousePressed){
           mousePressed=false;
           active=false;
           envelopes.add(new Envelope(this,args[i],i));
           Envelope curr = (Envelope)envelopes.get(envelopes.size()-1);
           curr.recording=true;
           }
         */

        fill(255);
        text(args[i],sh,-24);
        sh += tw+6;
      }

      popMatrix();

      if(execute){
        String tmp="";
        for(int ii = 0 ; ii < pre.size();ii++){
          String ttmp = (String)pre.get(ii);
          tmp+=ttmp;
        }


        for(int ii = 0 ; ii < lines.size();ii++){
          String ttmp = (String)lines.get(ii);
          tmp+=ttmp;
        }

        for(int ii = 0 ; ii < post.size();ii++){
          String ttmp = (String)post.get(ii);
          tmp+=ttmp;
        }


        println(tmp);
        execute(tmp);
        execute = false;
      }
    }catch(Exception e){println("editor draw errr!");}


  }

}


