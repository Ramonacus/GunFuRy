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

    GameObject player;
    Animator animator;

    Rigidbody2D enemyRb;
    public float speed = 2f;
    public float attackRange = 1f;

    void Awake()
    {
        player = GameObject.Find("Player");
        state = State.Idle;
        enemyRb = GetComponent<Rigidbody2D>();
        animator = GetComponentInChildren<Animator>();
    }

    void FixedUpdate()
    {
        Vector2 directionToPlayer = player.transform.position - transform.position;


        switch (state)
        {
            case State.Idle:
            case State.Walking:
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
            enemyRb.MovePosition(GetPosition2D() + directionToPlayer * speed * Time.deltaTime);
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

    public void EndAttack()
    {
        state = State.Idle;
        animator.SetBool("Attacking", false);
    }

    Vector2 GetPosition2D()
    {
        return new Vector2(transform.position.x, transform.position.y);
    }

    private void OnDrawGizmosSelected()
    {

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(GetPosition2D(), attackRange);
    }
}