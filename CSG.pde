import java.util.Comparator;

class HitCompare implements Comparator<RayHit>
{
  int compare(RayHit a, RayHit b)
  {
     if (a.t < b.t) return -1;
     if (a.t > b.t) return 1;
     if (a.entry) return -1;
     if (b.entry) return 1;
     return 0;
  }
}

class Union implements SceneObject
{
  SceneObject[] children;
  Union(SceneObject[] children)
  {
    this.children = children;
  }

  ArrayList<RayHit> intersect(Ray r)
  {
      ArrayList<RayHit> hits = new ArrayList<RayHit>();
      ArrayList<RayHit> trueHits = new ArrayList<RayHit>();
      int depth = 0;
      for (SceneObject sc : children)
      {
        //catches corner case of starting WITHIN an object
         ArrayList<RayHit> childHit = sc.intersect(r);
         if(childHit.size() > 0)
         {
             if(childHit.get(0).entry == false)
             {
               depth++;
             }
         }
         hits.addAll(childHit);
      }
      //sorts all hits based on t value
      hits.sort(new HitCompare());
      
      //iterates through all hits, tracking our depth. 
      for(int i = 0; i < hits.size(); i++)
      {
        //if we encounter an entry AND our depth is 0, its a true entry hit
        if(hits.get(i).entry == true)
        {
          if(depth == 0)
          {
            trueHits.add(hits.get(i));
            depth++;
          }
          else
          {
            depth++;
          }
        }
        //if we encounter an exit AND our depth is 1, then its a true exit hit
        else
        {
          if(depth == 1)
          {
            trueHits.add(hits.get(i));
            depth--;
          }
          else
          {
            depth--;
          }
        }
      }
      return trueHits;
  }
  
}

class Intersection implements SceneObject
{
  SceneObject[] children;
  Intersection(SceneObject[] children)
  {
    this.children = children;
  }
  ArrayList<RayHit> intersect(Ray r)
  {
      ArrayList<RayHit> hits = new ArrayList<RayHit>();
      ArrayList<RayHit> trueHits = new ArrayList<RayHit>();
      int depth = 0;
      for (SceneObject sc : children)
      {
         ArrayList<RayHit> childHit = sc.intersect(r);
         if(childHit.size() > 0)
         {
             if(childHit.get(0).entry == false)
             {
               depth++;
             }
         }
         hits.addAll(childHit);
      }
      hits.sort(new HitCompare());
      
      //iterate through all RayHit objects
      boolean nextHit = false;
      for(int i = 0; i < hits.size(); i++)
      {
        //if we encounter an entry AND our depth is how many children there is, its a true entry hit
        if(hits.get(i).entry == true && !nextHit)
        {
          if(depth == (children.length-1))
          {
            trueHits.add(hits.get(i));
            nextHit = true;
            depth++;
          }
          else
          {
            depth++;
          }
        }
        //if we encounter an exit AND we added an entry, then its a true exit hit
        else
        {
          if(nextHit)
          {
            trueHits.add(hits.get(i));
            break;
          }
          else
          {
            depth--;
          }
        }
      }
      return trueHits;
  }
  
}

class Difference implements SceneObject
{
  SceneObject a;
  SceneObject b;
  Difference(SceneObject a, SceneObject b)
  {
    this.a = a;
    this.b = b;
  }
  
  ArrayList<RayHit> intersect(Ray r)
  {
     ArrayList<RayHit> hits = new ArrayList<RayHit>();
     
     //state booleans, and preliminary check to see if we started within a or b or both
     boolean inA, inB;
     ArrayList<RayHit> aHit = a.intersect(r);
     ArrayList<RayHit> bHit = b.intersect(r);
     if(aHit.size() > 0)
     {
         if(aHit.get(0).entry == false)
         {
           inA = true;
         }
     }
     if(bHit.size() > 0)
     {
         if(bHit.get(0).entry == false)
         {
           inB = true;
         }
     }
     
     //push all RayHits into a sorted list based on t
     hits.addAll(a.intersect(r));
     hits.addAll(b.intersect(r));
     hits.sort(new HitCompare());
     
     //iterate over list
     for(int i = 0; i < hits.size(); i++)
     {
       
     }
     return hits;
  }
  
}
