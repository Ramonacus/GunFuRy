using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private enum State
    {
        Idle,
        Walking,
        Attacking
    }

    State state;

    [SerializeField] float attackCooldown = .3f;
    float attackTimer;
    public float attackRange;
    public LayerMask damageMask;
    public float damage = 10f;

    Rigidbody2D playerRb;
    [SerializeField] float speed = 5f;
    Vector2 direction;

    void Awake()
    {
        // Set starting status and initial direction
        state = State.Idle;
        direction = new Vector2(1, 0);
        playerRb = GetComponent<Rigidbody2D>();
    }

    void FixedUpdate()
    {
        switch (state)
        {
            case State.Idle:
            case State.Walking:
                StandingUpdate();
                break;
            case State.Attacking:
                AttackUpdate();
                break;
        }
    }

    void StandingUpdate()
    {
        // Get the user directional input and clamp it to 1
        float verticalInput = Input.GetAxis("Vertical");
        float horizontalInput = Input.GetAxis("Horizontal");
        Vector2 directionInput = new Vector2(horizontalInput, verticalInput);
        directionInput = Vector2.ClampMagnitude(directionInput, 1);

        // Calculate direction of the character
        if (directionInput.magnitude > .1f)
        {
            state = State.Walking;
            direction = directionInput.normalized;
        }
        else
        {
            state = State.Idle;
        }

        // Attack or move?
        if (Input.GetButton("Fire1") || Input.GetKey(KeyCode.Space))
        {
            state = State.Attacking;
            attackTimer = attackCooldown;
            Attack();
        }
        else
        {
            playerRb.MovePosition(GetPosition2D() + directionInput * speed * Time.deltaTime);
        }

    }

    void AttackUpdate()
    {
        attackTimer = attackTimer - Time.deltaTime;
        if (attackTimer <= 0)
        {
            state = State.Idle;
        }
    }

    void Attack()
    {
        Collider2D[] objectsToDamage = Physics2D.OverlapCircleAll(AttackPosition(), attackRange, damageMask);
        for (int i = 0; i < objectsToDamage.Length; i++)
        {
            objectsToDamage[i].GetComponentInParent<Health>().TakeDamage(damage);
        }
    }

    Vector2 GetPosition2D()
    {
        return new Vector2(transform.position.x, transform.position.y);
    }

    Vector2 AttackPosition()
    {
        return GetPosition2D() + direction;
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(AttackPosition(), attackRange);
    }
}

