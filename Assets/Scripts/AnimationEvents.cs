using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationEvents : MonoBehaviour
{
    public void OnAttackEnd()
    {
        GetComponentInParent<ZombiMovement>().EndAttack();
    }
}
