t2/*
misc_infight

target = monster that gets mad
target2 = who target1 will be angry at

spawnflag 1 = mutual hate, both targets get angry at each other instantly
*/

float INFIGHT_MUTUAL = 1;
float INFIGHT_PLAYER_ACTIVATION = 2;

void(entity t1, entity t2) make_angry_at =
{
    if (t2.health > 0 && t1.health > 0) { // checks if both are alive
        if (t1.enemy.classname == "player")
            t1.oldenemy = t1.enemy;
        t1.enemy = t2;

        entity oself = self;
        self = t1; // FoundTarget() only acts on self
        FoundTarget();
        self = oself;
    }
};

void() misc_infight_use =
{
    local entity    t1, t2;

    t1 = find(world, targetname, self.target);
    t2 = find(world, targetname, self.target2);
    if (!t1)
    {
        dprint("[trigger_infight] Cannot find target, checking targetname2\n");
        t1 = find(world, targetname2, self.target);
    }
    if (!t1)
    {
        dprint("[trigger_infight] Cannot find target, checking targetname3\n");
        t1 = find(world, targetname3, self.target);
    }
    if (!t1)
    {
        dprint("[trigger_infight] Cannot find target, checking targetname4\n");
        t1 = find(world, targetname4, self.target);
    }
    if (!t1)
    {
        dprint("[trigger_infight] Cannot find target, exhausted all targetnames\n");
        return;
    }
    if (!t2)
    {
        dprint("[trigger_infight] Cannot find target2 checking targetname2\n");
        t2 = find(world, targetname2, self.target2);
    }
    if (!t2)
    {
        dprint("[trigger_infight] Cannot find target2 checking targetname3\n");
        t2 = find(world, targetname3, self.target2);
    }
    if (!t2)
    {
        dprint("[trigger_infight] Cannot find target2 checking targetname4\n");
        t2 = find(world, targetname4, self.target2);
    }
    if (!t2)
    {
        dprint("[trigger_infight] Cannot find target2, exhausted all targetnames\n");
        return;
    }

    make_angry_at(t1, t2);

    if (self.spawnflags & INFIGHT_MUTUAL)
        make_angry_at(t2, t1);


    if (self.spawnflags & INFIGHT_PLAYER_ACTIVATION)
    {
      t1.passthru = activator;
      t2.passthru = activator;
    }
};

void() misc_infight =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    self.use = misc_infight_use;
};
