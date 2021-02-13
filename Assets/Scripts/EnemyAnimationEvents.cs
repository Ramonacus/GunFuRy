using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAnimationEvents : MonoBehaviour
{
    public void OnAttackHitbox()
    {
        GetComponentInParent<EnemyMovement>().ActivateHitbox();
    }

    public void OnAttackEnd()
    {
        GetComponentInParent<EnemyMovement>().EndAttack();
    }
}
