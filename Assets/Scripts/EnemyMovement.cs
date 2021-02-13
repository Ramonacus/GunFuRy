using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyMovement : MonoBehaviour
{
    private enum State
    {
        Idle,
        Walking,
        Attacking
    }
    State state;

    public float attackArea;
    public LayerMask damageMask;
    public float attackRange;
    public float damage;

    Rigidbody2D rbody;
    [SerializeField] float speed;

    Animator animator;

    GameObject player;

    void Awake()
    {
        player = GameObject.Find("Player");
        state = State.Idle;
        rbody = GetComponent<Rigidbody2D>();
        animator = GetComponentInChildren<Animator>();
    }

    void FixedUpdate()
    {
        switch (state)
        {
            case State.Idle:
            case State.Walking:
                Vector2 directionToPlayer = player.transform.position - transform.position;
                StandingUpdate(directionToPlayer);
                break;
            case State.Attacking:
                break;
        }
    }

    void StandingUpdate(Vector2 directionToPlayer)
    {
        // TODO replace with actual animations for moving left
        transform.rotation = new Quaternion(0, directionToPlayer.x > 0 ? 0 : 180, 0, 0);

        if (directionToPlayer.magnitude > attackRange)
        {
            animator.SetBool("Attacking", false);
            directionToPlayer = Vector2.ClampMagnitude(directionToPlayer, 1);
            rbody.MovePosition(GetPosition2D() + directionToPlayer * speed * Time.deltaTime);
        }
        else
        {
            Attack(directionToPlayer.normalized);
        }
    }

    void Attack(Vector2 direction)
    {
        state = State.Attacking;
        animator.SetBool("Attacking", true);
    }

    Vector2 GetPosition2D() => new Vector2(transform.position.x, transform.position.y);

    public void EndAttack()
    {
        state = State.Idle;
        animator.SetBool("Attacking", false);
    }

    public void ActivateHitbox() => Debug.Log("Enemy hits!");

}